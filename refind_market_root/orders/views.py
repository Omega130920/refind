from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.core.mail import send_mail
from listings.models import Item
from .models import Order

from listings.shipping_utils import BobGoClient
from django.http import JsonResponse
from decimal import Decimal

from django.conf import settings
import requests

from django.http import HttpResponse # Add this
import time

from django.db.models import Q
import json

@login_required
def checkout(request, item_id):
    # Fetch item and ensure it has stock available
    item = get_object_or_404(Item, id=item_id)
    
    if not item.is_available:
        messages.error(request, "This item is currently out of stock.")
        return redirect('item_list')

    if request.method == 'POST':
        # Get requested quantity from form, default to 1
        try:
            requested_qty = int(request.POST.get('requested_quantity', 1))
        except ValueError:
            requested_qty = 1

        # 1. Validation: Prevent buying own item
        if item.seller == request.user:
            messages.error(request, "You cannot buy your own item.")
            return redirect('item_detail', pk=item.id)

        # 2. Validation: Check if requested amount exceeds available stock
        if requested_qty > item.available_stock:
            messages.error(request, f"Sorry, only {item.available_stock} units are available.")
            return redirect('item_detail', pk=item.id)

        # 3. Validation: Prevent duplicate pending orders for the same item by same user
        # Note: You might want to allow this if they want to buy more later, 
        # but for now, we follow your existing logic.
        existing_order = Order.objects.filter(item=item, buyer=request.user, status='pending_approval').first()
        if existing_order:
            messages.info(request, "You already have a pending request for this item.")
            return redirect('item_detail', pk=item.id)

        # 4. Calculation: Total price = (Item Price * 1.075) * Quantity
        unit_price = item.display_price
        total_price = unit_price * requested_qty

        # 5. Create the Order
        # Note: You need to add a 'quantity' field to your Order model if it doesn't exist!
        new_order = Order.objects.create(
            item=item,
            buyer=request.user,
            seller=item.seller,
            amount=total_price,
            quantity=requested_qty, # Add this to your Order model
            status='pending_approval'
        )

        # 6. Notify the seller
        try:
            send_mail(
                'Refind Market - New Purchase Request!',
                f'Hi {item.seller.username}, {request.user.username} wants to buy {requested_qty}x "{item.title}" for a total of R{total_price}. Visit your dashboard to respond.',
                'noreply@refindmarket.co.za',
                [item.seller.email],
                fail_silently=False,
            )
        except Exception as e:
            print(f"Email failed: {e}")

        messages.success(request, f"Request for {requested_qty} unit(s) sent! Total: R{total_price}")
        return redirect('item_detail', pk=item.id)

    return redirect('item_detail', pk=item.id)

@login_required
def my_purchases(request):
    # Now we fetch ALL orders for this buyer, regardless of status
    purchases = Order.objects.filter(buyer=request.user).order_by('-created_at')
    return render(request, 'orders/my_purchases.html', {'purchases': purchases})

@login_required
def finalize_payment(request, order_id):
    # Fetch order - ensures buyer is the one paying
    order = get_object_or_404(Order, id=order_id, buyer=request.user, status='shipping_set')

    if request.method == 'POST':
        print(f"\n--- PAYMENT PROCESSING START ---")
        print(f"Order ID: {order.id}")
        print(f"Buyer: {request.user.username}")
        
        # 1. Update order status
        order.status = 'paid'
        order.save()
        print(f"STATUS UPDATED: {order.status}")

        # 2. Update the Inventory
        item = order.item
        # Update the quantity sold count
        item.quantity_sold += order.quantity
        
        # Direct column comparison to decide visibility
        if item.quantity_sold >= item.total_quantity:
            item.is_sold = True
        else:
            # Crucial: explicitly keep it available if stock remains
            item.is_sold = False 
            
        item.save()
        print(f"INVENTORY UPDATED: {item.title} (Sold: {item.quantity_sold}/{item.total_quantity})")

        # 3. Terminal Success Print
        print(f"PAYMENT SUCCESS: R{order.total_with_shipping} received.")
        print(f"--- PAYMENT PROCESSING END ---\n")

        # Redirect to the success page
        return render(request, 'orders/payment_success.html', {'order': order})
    
    # If GET, show the confirmation page with the POST button
    return render(request, 'orders/finalize_confirmation.html', {'order': order})

@login_required
def shipping_from(request, order_id):
    """ Step 1: Seller sets the 'Ship From' address, Parcel Dimensions, and Method """
    order = get_object_or_404(Order, id=order_id, seller=request.user)
    
    if request.method == 'POST':
        print(f"\n--- DEBUG: SHIPPING_FROM SUBMISSION [Order {order.id}] ---")
        
        # Capture raw values from the POST request
        raw_street = request.POST.get('street_address')
        raw_method = request.POST.get('shipping_method')
        raw_weight = request.POST.get('weight')
        
        print(f"DEBUG: Form Method Value Received: {raw_method}")
        print(f"DEBUG: Form Weight Value Received: {raw_weight}")
        print(f"DEBUG: Form Street Value Received: {raw_street}")

        # 1. Update the object attributes in memory
        order.collection_street = raw_street
        order.collection_suburb = request.POST.get('local_area')
        order.collection_city = request.POST.get('city')
        order.collection_postcode = request.POST.get('code')
        order.collection_province_code = request.POST.get('province_code', 'GP')
        
        order.parcel_weight = Decimal(raw_weight) if raw_weight else Decimal('1.0')
        order.parcel_length = int(request.POST.get('length', 10))
        order.parcel_width = int(request.POST.get('width', 10))
        order.parcel_height = int(request.POST.get('height', 10))
        
        order.preferred_method = raw_method if raw_method else 'any'
        order.status = 'accepted' 
        
        # 2. FORCE SAVE SPECIFIC COLUMNS
        # Using update_fields ensures that Django explicitly includes these in the UPDATE SQL
        # Now that 'preferred_method' is in models.py, this will successfully reach the DB
        save_fields = [
            'collection_street', 'collection_suburb', 'collection_city', 
            'collection_postcode', 'collection_province_code',
            'parcel_weight', 'parcel_length', 'parcel_width', 'parcel_height',
            'preferred_method', 'status'
        ]
        
        try:
            order.save(update_fields=save_fields)
            print("DEBUG: order.save(update_fields=...) executed successfully.")
        except Exception as e:
            print(f"DEBUG: SAVE ERROR: {e}")

        # 3. Final Verification (Pulling fresh data from the DB)
        order.refresh_from_db()
        print(f"DEBUG: FINAL DB CHECK - method in DB is: {order.preferred_method}")
        print(f"DEBUG: FINAL DB CHECK - street in DB is: {order.collection_street}")
        print(f"--- DEBUG END ---\n")
        
        return redirect('my_listings')
        
    return render(request, 'orders/shipping_from.html', {'order': order})

@login_required
def shipping_to(request, order_id):
    """ Step 2: Buyer sets 'Ship To' and selects from live rates """
    # Ensure only the buyer can access this
    order = get_object_or_404(Order, id=order_id, buyer=request.user)
    
    if request.method == 'POST':
        # 1. Save specific delivery details
        order.delivery_street = request.POST.get('delivery_street')
        order.delivery_city = request.POST.get('delivery_city')
        order.delivery_postcode = request.POST.get('delivery_code')
        
        # 2. Save the specific Bob Go selection (including the required Provider Slug)
        order.bobgo_service_code = request.POST.get('selected_rate_code')
        order.bobgo_provider_slug = request.POST.get('selected_provider_slug')  # CAPTURING THE SLUG
        
        # Convert price string to Decimal for the DB
        raw_price = request.POST.get('selected_rate_price', '0.00')
        order.shipping_cost = Decimal(raw_price)
        
        # 3. Update Status
        order.status = 'shipping_set'
        
        # 4. Save using update_fields for unmanaged table safety
        # This ensures MySQL explicitly receives the new slug
        order.save(update_fields=[
            'delivery_street', 
            'delivery_city', 
            'delivery_postcode', 
            'bobgo_service_code', 
            'bobgo_provider_slug', 
            'shipping_cost', 
            'status'
        ])
        
        print(f"DEBUG: Saved shipping for Order {order.id}. Provider: {order.bobgo_provider_slug}")
        
        # Redirect to your payment finalization view
        return redirect('finalize_payment', order_id=order.id)
        
    return render(request, 'orders/shipping_to.html', {'order': order})

@login_required
def get_bobgo_rates_ajax(request):
    """ AJAX helper updated to use the Seller's saved parcel dimensions """
    order_id = request.GET.get('order_id')
    dest_code = request.GET.get('dest_code')
    order = get_object_or_404(Order, id=order_id)
    
    # Simple zone mapping for South Africa
    dest_zone = "WC" if dest_code.startswith('7') else "GP"

    payload = {
        "collection_address": {
            "street_address": order.collection_street,
            "company": "",
            "local_area": order.collection_suburb,
            "city": order.collection_city,
            "zone": order.collection_province_code, 
            "country": "ZA",
            "code": order.collection_postcode
        },
        "delivery_address": {
            "street_address": "Pending", 
            "company": "",
            "local_area": "Pending",
            "city": "Cape Town" if dest_zone == "WC" else "Johannesburg",
            "zone": dest_zone, 
            "country": "ZA",
            "code": dest_code
        },
        # Now using the actual dimensions saved by the seller in Step 1
        "parcels": [{
            "description": f"Parcel for {order.item.title}",
            "submitted_length_cm": int(order.parcel_length),
            "submitted_width_cm": int(order.parcel_width),
            "submitted_height_cm": int(order.parcel_height),
            "submitted_weight_kg": float(order.parcel_weight)
        }],
        "collection_contact_mobile_number": getattr(order.seller, 'phone_number', '0123456789'),
        "collection_contact_email": order.seller.email,
        "collection_contact_full_name": order.seller.get_full_name() or order.seller.username,
        "delivery_contact_mobile_number": getattr(order.buyer, 'phone_number', '0123456789'),
        "delivery_contact_email": order.buyer.email,
        "delivery_contact_full_name": order.buyer.get_full_name() or order.buyer.username,
        "declared_value": float(order.amount),
        "timeout": 10000
    }
    
    client = BobGoClient()
    response = client.get_rates(payload) 
    return JsonResponse(response)

def proxy_pdf_download(waybill_url, tracking_ref):
    """ Helper to retry and download the PDF content to hide the API origin """
    if not waybill_url:
        return None
        
    for attempt in range(4): # Increased to 4 attempts
        print(f"DEBUG: Proxy download attempt {attempt + 1} for {tracking_ref}")
        try:
            pdf_res = requests.get(waybill_url, timeout=10)
            if pdf_res.status_code == 200:
                print(f"DEBUG: Success! PDF content captured for {tracking_ref}")
                response = HttpResponse(pdf_res.content, content_type='application/pdf')
                # White-label the filename
                filename = f"ReFind-Waybill-{tracking_ref}.pdf"
                response['Content-Disposition'] = f'attachment; filename="{filename}"'
                return response
            else:
                print(f"DEBUG: File not ready (Status {pdf_res.status_code})")
        except Exception as e:
            print(f"DEBUG: Connection error during download: {str(e)}")
        
        time.sleep(1.5) # Wait between retries
    return None

@login_required
def generate_waybill(request, order_id):
    """
    Handles Waybill Generation (Seller only) and Waybill Downloads (Seller & Buyer).
    Proxies PDF binary to hide Bob Go origin.
    """
    # 1. Fetch the Order - Allow access if user is Seller OR Buyer
    order = get_object_or_404(
        Order, 
        Q(seller=request.user) | Q(buyer=request.user),
        id=order_id
    )
    
    # 2. Security Check: Only seller can access if status is 'paid' (to generate)
    # If buyer tries to access before it's shipped, redirect them.
    if order.status == 'paid' and order.seller != request.user:
        messages.info(request, "The seller hasn't generated the waybill yet.")
        return redirect('my_purchases')

    headers = {
        "Authorization": f"Bearer {settings.BOBGO_API_KEY}", 
        "Content-Type": "application/json"
    }
    base_endpoint = f"{settings.BOBGO_BASE_URL}/shipments"

    # --- CASE 1: DOWNLOAD FLOW (FOR SHIPPED ORDERS) ---
    # Accessible by both Seller and Buyer
    if order.status == 'shipped' and order.tracking_number:
        print(f"\n--- DEBUG: PROXY DOWNLOAD START (User: {request.user.username}) ---")
        
        final_pdf_link = None
        for url_attempt in range(1, 6):
            tracking_array = json.dumps([order.tracking_number])
            wb_endpoint = f"{base_endpoint}/waybill?tracking_references={tracking_array}"
            
            wb_res = requests.get(wb_endpoint, headers=headers, timeout=10)
            
            if wb_res.status_code == 200:
                data = wb_res.json()
                final_pdf_link = data.get('download_url') or data.get('waybill_url')
                
                if not final_pdf_link and isinstance(data, list) and len(data) > 0:
                    final_pdf_link = data[0].get('download_url') or data[0].get('waybill_url')

                if final_pdf_link:
                    print(f"DEBUG: Success! Found Link: {final_pdf_link}")
                    break
            time.sleep(2)

        if final_pdf_link:
            for pdf_attempt in range(1, 5):
                pdf_res = requests.get(final_pdf_link, timeout=15)
                if pdf_res.status_code == 200:
                    response = HttpResponse(pdf_res.content, content_type='application/pdf')
                    filename = f"ReFind-Waybill-{order.tracking_number}.pdf"
                    response['Content-Disposition'] = f'attachment; filename="{filename}"'
                    return response
                time.sleep(2)
        
        messages.warning(request, "Waybill is still generating. Please try again in 10 seconds.")
        # Redirect based on who is asking
        return redirect('my_listings' if order.seller == request.user else 'my_purchases')

    # --- CASE 2: GENERATION FLOW (FOR PAID ORDERS) ---
    # Strictly for Seller only
    p_weight = float(order.parcel_weight) if order.parcel_weight else 1.0
    p_dims = [
        int(order.parcel_length) if order.parcel_length else 10, 
        int(order.parcel_width) if order.parcel_width else 10, 
        int(order.parcel_height) if order.parcel_height else 10
    ]

    payload = {
        "collection_address": {
            "street_address": order.collection_street,
            "company": "Re-Find Market",
            "local_area": order.collection_suburb,
            "city": order.collection_city,
            "zone": order.collection_province_code,
            "country": "ZA",
            "code": order.collection_postcode
        },
        "collection_contact_name": order.seller.get_full_name() or order.seller.username,
        "collection_contact_mobile_number": getattr(order.seller, 'phone_number', "0123456789"),
        "collection_contact_email": order.seller.email,
        "delivery_address": {
            "street_address": order.delivery_street,
            "company": "Re-Find Market",
            "local_area": order.delivery_city,
            "city": order.delivery_city,
            "zone": order.delivery_province_code,
            "country": "ZA",
            "code": order.delivery_postcode
        },
        "delivery_contact_name": order.buyer.get_full_name() or order.buyer.username,
        "delivery_contact_mobile_number": "0987654321",
        "delivery_contact_email": order.buyer.email,
        "parcels": [{
            "description": f"Parcel for {order.item.title}",
            "submitted_length_cm": p_dims[0],
            "submitted_width_cm": p_dims[1],
            "submitted_height_cm": p_dims[2],
            "submitted_weight_kg": p_weight
        }],
        "declared_value": float(order.amount),
        "service_level_code": order.bobgo_service_code,
        "provider_slug": order.bobgo_provider_slug,
        "timeout": 20000
    }

    try:
        response = requests.post(base_endpoint, headers=headers, json=payload, timeout=20)
        data = response.json()
        
        if response.status_code in [200, 201]:
            tracking_ref = data.get('tracking_reference')
            order.tracking_number = tracking_ref
            order.status = 'shipped'
            order.save(update_fields=['tracking_number', 'status'])
            
            item = order.item
            item.is_sold = True
            item.save(update_fields=['is_sold'])

            # Simulated Terminal Email
            subject = f"Your Re-Find order for {item.title} has shipped!"
            message = (
                f"Hi {order.buyer.username},\n\n"
                f"Great news! Your item '{item.title}' is on its way.\n"
                f"Tracking Number: {tracking_ref}\n\n"
                f"Thank you for shopping with Re-Find!"
            )
            send_mail(subject, message, 'no-reply@refindmarket.co.za', [order.buyer.email])
            print(f"DEBUG: Shipping notification printed to terminal for {order.buyer.email}")

            return redirect('generate_waybill', order_id=order.id)
        else:
            messages.error(request, f"Courier Error: {data.get('message', 'Validation failed')}")
    except Exception as e:
        messages.error(request, f"System error: {str(e)}")

    return redirect('my_listings')