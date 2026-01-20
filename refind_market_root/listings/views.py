from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.db.models import Sum, Q, Avg # Added Avg here
from django.contrib.auth import get_user_model
from django.core.mail import send_mail
from .models import SupportChat, SupportMessage
import json
from django.http import JsonResponse
from django.contrib.auth.decorators import user_passes_test
from django.urls import reverse

# Imports from your local models
from .models import Item, ItemImage, Review, Message, Report  
from .forms import ItemCreateForm
from orders.models import Order

#Bobgo
from .shipping_utils import BobGoClient

from users.views import notify_followers

from django.db.models import Q, F

# This correctly identifies your custom User model
User = get_user_model()

def landing_page(request):
    """
    The very first page guests see. 
    Redirects logged-in users to the main marketplace.
    """
    if request.user.is_authenticated:
        return redirect('item_list') # Redirect to the member marketplace
    
    return render(request, 'listings/index.html')

@login_required
def item_list(request):
    # Base Query: using F to compare total vs sold
    items = Item.objects.filter(
        is_sold=False, 
        show_on_marketplace=True,
        total_quantity__gt=F('quantity_sold')
    ).prefetch_related('images').select_related('seller', 'seller__vendor_profile')

    # Get search parameters
    query = request.GET.get('q')
    vendor_query = request.GET.get('vendor')
    location_query = request.GET.get('location')
    category = request.GET.get('category')
    max_price = request.GET.get('max_price') 

    # 1. Search Filter
    if query:
        items = items.filter(Q(title__icontains=query) | Q(description__icontains=query))
    
    # 2. Vendor/User Filter
    if vendor_query:
        items = items.filter(
            Q(seller__username__icontains=vendor_query) | 
            Q(seller__vendor_profile__business_name__icontains=vendor_query)
        ).distinct()
    
    # 3. Location Filter
    if location_query:
        items = items.filter(
            Q(suburb__icontains=location_query) | 
            Q(city__icontains=location_query) | 
            Q(region__icontains=location_query)
        ).distinct()

    # 4. Category Filter
    if category:
        items = items.filter(category__icontains=category)

    # 5. Max Price Filter
    if max_price:
        try:
            max_base_price = float(max_price) / 1.075
            items = items.filter(price__lte=max_base_price)
        except ValueError:
            pass

    items = items.order_by('-created_at')

    # INVENTORY LOGIC: Calculate remaining stock for each item for the HTML badges
    for item in items:
        item.remaining_stock = item.total_quantity - item.quantity_sold
        # We also pass a negative version for the template's |add filter if needed
        item.quantity_sold_neg = -item.quantity_sold

    return render(request, 'listings/item_list.html', {
        'items': items,
        'query': query,
        'vendor_query': vendor_query,
        'location_query': location_query,
        'category': category,
        'max_price': max_price, 
    })

def item_detail(request, pk):
    item = get_object_or_404(Item.objects.prefetch_related('images'), pk=pk)
    # Also calculate remaining stock for the detail page
    item.remaining_stock = item.total_quantity - item.quantity_sold
    return render(request, 'listings/item_detail.html', {'item': item})


from django.db import transaction

@login_required
def item_create(request):
    if request.method == 'POST':
        # Pass request.user so the Form's __init__ can check for Vendor status
        form = ItemCreateForm(request.POST, request.FILES, user=request.user)
        
        if form.is_valid():
            # Check if at least one image exists
            has_image = any([
                form.cleaned_data.get('image1'),
                form.cleaned_data.get('image2'),
                form.cleaned_data.get('image3'),
                form.cleaned_data.get('image4'),
                form.cleaned_data.get('image5'),
                form.cleaned_data.get('image6')
            ])

            if not has_image:
                messages.error(request, "Please upload at least one image to publish your listing.")
                return render(request, 'listings/item_form.html', {'form': form})

            # 1. Save the Item first (commit=False)
            item = form.save(commit=False)
            item.seller = request.user
            
            # --- Save Inventory Data ---
            item.total_quantity = form.cleaned_data.get('total_quantity', 1)
            item.quantity_sold = 0 
            
            # --- Save Visibility Control ---
            # This captures whether the vendor wants it on the main market or just their store
            item.show_on_marketplace = form.cleaned_data.get('show_on_marketplace', True)
            
            # --- Save Location Data ---
            item.region = form.cleaned_data.get('region')
            item.city = form.cleaned_data.get('city')
            item.suburb = form.cleaned_data.get('suburb')
            
            item.save()
            
            # 2. MANUALLY SAVE THE GALLERY IMAGES
            for i in range(1, 7):
                field_name = f'image{i}'
                image_file = form.cleaned_data.get(field_name)
                if image_file:
                    ItemImage.objects.create(item=item, image=image_file)

            # --- VENDOR NOTIFICATION TRIGGER ---
            if hasattr(request.user, 'vendor_profile'):
                notify_followers(request.user.vendor_profile, item, action_type="new")
            
            messages.success(request, f"Listing published successfully!")
            return redirect('item_list')
        else:
            messages.error(request, "Please correct the errors below.")
    else:
        # Pre-fill with User's Location and pass user to the form
        initial_data = {
            'region': request.user.region,
            'city': request.user.city,
            'suburb': request.user.suburb,
            'total_quantity': 1,
            'show_on_marketplace': True,
        }
        form = ItemCreateForm(initial=initial_data, user=request.user)
        
    return render(request, 'listings/item_form.html', {'form': form})

@login_required
def my_listings(request):
    # Fetch active items (not yet fully sold)
    active_items = Item.objects.filter(
        seller=request.user, 
        is_sold=False
    ).prefetch_related('order_set').order_by('-created_at')
    
    # Get the number of pending buy requests
    pending_requests_count = Order.objects.filter(
        item__seller=request.user, 
        status='pending_approval' # Note: Update to match your actual 'pending' status string
    ).count()
    
    # --- ACTION REQUIRED ---
    # Fetch orders that are paid but not yet shipped
    # This matches the 'paid_orders' variable in your HTML template
    paid_orders = Order.objects.filter(
        seller=request.user, 
        status='paid'
    ).select_related('item')

    # Fetch sold history (both paid and shipped items for the history table)
    from django.db.models import Q
    sold_orders = Order.objects.filter(
        seller=request.user
    ).filter(
        Q(status='paid') | Q(status='shipped')
    ).select_related('item').order_by('-created_at')
    
    # Calculate earnings based on total payout (item amount + shipping if applicable)
    total_payout = sum(order.amount for order in sold_orders)

    return render(request, 'listings/my_listings.html', {
        'items': active_items,
        'paid_orders': paid_orders,        # NEW: Required for the Generate Waybill card
        'sold_orders': sold_orders,
        'total_earnings': total_payout,
        'pending_requests_count': pending_requests_count,
    })
    
@login_required
def item_edit(request, pk):
    item = get_object_or_404(Item, pk=pk)
    if item.seller != request.user:
        messages.error(request, "Unauthorized.")
        return redirect('item_list')

    if request.method == 'POST':
        # Capture the old quantity BEFORE saving the form
        old_total_qty = item.total_quantity
        
        # Pass request.user so the Form's __init__ can handle the visibility toggle
        form = ItemCreateForm(request.POST, request.FILES, instance=item, user=request.user)
        
        if form.is_valid():
            # Save the item
            updated_item = form.save(commit=False)
            
            # --- Ensure Visibility Control is updated ---
            # If the user is a vendor, they might have toggled this
            updated_item.show_on_marketplace = form.cleaned_data.get('show_on_marketplace', True)
            
            updated_item.save()
            
            # TRIGGER NOTIFICATION
            if hasattr(request.user, 'vendor_profile'):
                if updated_item.total_quantity > old_total_qty:
                    # Call the helper from users/views.py
                    notify_followers(request.user.vendor_profile, updated_item, action_type="restock")
            
            # Gallery image logic (if you are adding more during edit)
            images = request.FILES.getlist('images')
            if images:
                for f in images:
                    ItemImage.objects.create(item=updated_item, image=f)
            
            messages.success(request, "Item updated successfully!")
            return redirect('my_listings')
    else:
        # Pass user to the form on GET request so the toggle appears
        form = ItemCreateForm(instance=item, user=request.user)
        
    return render(request, 'listings/item_form.html', {'form': form, 'edit_mode': True})

@login_required
def item_delete(request, pk):
    item = get_object_or_404(Item, pk=pk)
    if item.seller != request.user:
        messages.error(request, "You can only delete your own listings.")
        return redirect('item_list')

    if request.method == 'POST':
        item.delete()
        messages.success(request, f"Item '{item.title}' has been deleted.")
        return redirect('my_listings')
    return render(request, 'listings/item_confirm_delete.html', {'item': item})

def payment_success(request, item_id):
    item = get_object_or_404(Item, id=item_id)
    item.is_sold = True 
    item.save()
    return render(request, 'orders/success.html')

@login_required
def manage_requests(request, item_id):
    item = get_object_or_404(Item, id=item_id, seller=request.user)
    requests = Order.objects.filter(item=item, status='pending_approval').order_by('-created_at')

    if request.method == 'POST':
        order_id = request.POST.get('order_id')
        action = request.POST.get('action') 
        target_order = get_object_or_404(Order, id=order_id, item=item)

        if action == 'accept':
            target_order.status = 'accepted'
            target_order.save()
            item.is_sold = True
            item.save()
            Order.objects.filter(item=item, status='pending_approval').exclude(id=order_id).update(status='declined')
            messages.success(request, f"You have accepted {target_order.buyer.username}'s request!")
            return redirect('my_listings')
        elif action == 'decline':
            target_order.status = 'declined'
            target_order.save()
            return redirect('manage_requests', item_id=item.id)

    return render(request, 'listings/manage_requests.html', {'item': item, 'requests': requests})

@login_required
def chat(request, item_id, recipient_id):
    item = get_object_or_404(Item, id=item_id)
    recipient = get_object_or_404(User, id=recipient_id)
    
    Message.objects.filter(item=item, sender=recipient, recipient=request.user, is_read=False).update(is_read=True)
    
    chat_history = Message.objects.filter(item=item).filter(
        (Q(sender=request.user) & Q(recipient=recipient)) |
        (Q(sender=recipient) & Q(recipient=request.user))
    ).order_by('timestamp')

    if request.method == 'POST':
        content = request.POST.get('content')
        if content:
            Message.objects.create(item=item, sender=request.user, recipient=recipient, content=content)
            try:
                send_mail(
                    'New Message on Refind Market',
                    f'Hi {recipient.username}, you have a new message from {request.user.username} regarding "{item.title}".',
                    'noreply@refindmarket.co.za',
                    [recipient.email],
                    fail_silently=False,
                )
            except:
                pass
            return redirect('chat', item_id=item.id, recipient_id=recipient.id)

    return render(request, 'listings/chat.html', {'item': item, 'recipient': recipient, 'chat_history': chat_history})
    
@login_required
def inbox(request):
    messages_qs = Message.objects.filter(Q(sender=request.user) | Q(recipient=request.user)).order_by('-timestamp')
    conversations = []
    seen_conversations = set()

    for msg in messages_qs:
        other_user = msg.recipient if msg.sender == request.user else msg.sender
        conv_id = f"{msg.item.id}-{other_user.id}"
        if conv_id not in seen_conversations:
            conversations.append({'item': msg.item, 'other_user': other_user, 'last_message': msg})
            seen_conversations.add(conv_id)
    return render(request, 'listings/inbox.html', {'conversations': conversations})

@login_required
def delete_conversation(request, item_id, other_user_id):
    if request.method == 'POST':
        other_user = get_object_or_404(User, id=other_user_id)
        item = get_object_or_404(Item, id=item_id)
        Message.objects.filter(item=item).filter(
            (Q(sender=request.user) & Q(recipient=other_user)) |
            (Q(sender=other_user) & Q(recipient=request.user))
        ).delete()
    return redirect('inbox')

@login_required
def leave_review(request, order_id):
    order = get_object_or_404(Order, id=order_id, buyer=request.user, status='paid')
    if Review.objects.filter(order=order).exists():
        return redirect('my_purchases')

    if request.method == 'POST':
        Review.objects.create(
            order=order, reviewer=request.user, target_user=order.seller,
            rating=request.POST.get('rating'), comment=request.POST.get('comment')
        )
        return redirect('my_purchases')
    return render(request, 'listings/leave_review.html', {'order': order})

def seller_profile(request, user_id):
    seller = get_object_or_404(User, id=user_id)
    avg_rating = Review.objects.filter(target_user=seller).aggregate(Avg('rating'))['rating__avg']
    rating_value = round(avg_rating, 1) if avg_rating else 0
    seller_reviews = Review.objects.filter(target_user=seller).order_by('-created_at')
    active_listings = Item.objects.filter(seller=seller, is_sold=False).order_by('-created_at')

    return render(request, 'listings/seller_profile.html', {
        'seller': seller, 'rating_value': rating_value, 'reviews': seller_reviews, 'listings': active_listings
    })
    
@login_required
def report_item(request, item_id):
    item = get_object_or_404(Item, id=item_id)
    if request.method == 'POST':
        Report.objects.create(
            item=item, reporter=request.user, 
            reason=request.POST.get('reason'), description=request.POST.get('description')
        )
        messages.success(request, "The listing has been reported for review.")
        return redirect('item_detail', pk=item.id)
    return render(request, 'listings/report_item.html', {'item': item})

def public_marketplace(request):
    """
    Publicly accessible gallery to attract new users.
    Includes Search, Category, Location, and Price filtering.
    """
    # Start with all items that are not sold
    items = Item.objects.filter(is_sold=False).prefetch_related('images').order_by('-created_at')

    # 1. Search Filter (Title and Description)
    query = request.GET.get('q')
    if query:
        items = items.filter(
            Q(title__icontains=query) | 
            Q(description__icontains=query)
        )

    # 2. Location Filter (Robust check across all location fields)
    location_query = request.GET.get('location')
    if location_query:
        items = items.filter(
            Q(suburb__icontains=location_query) | 
            Q(city__icontains=location_query) | 
            Q(region__icontains=location_query)
        ).distinct()

    # 3. Category Filter
    category = request.GET.get('category')
    if category:
        items = items.filter(category=category)

    # 4. Price Filter (Maximum Price)
    max_price = request.GET.get('max_price')
    if max_price:
        try:
            # Reverse the 7.5% markup math to filter against base 'price' in DB
            max_base_price = float(max_price) / 1.075
            items = items.filter(price__lte=max_base_price)
        except ValueError:
            pass

    context = {
        'items': items,
        'query': query,
        'location_query': location_query,
        'category': category,
        'max_price': max_price,
        'CATEGORY_CHOICES': Item.CATEGORY_CHOICES, # Crucial for the HTML dropdown
    }
    return render(request, 'listings/public_marketplace.html', context)


def public_item_detail(request, pk):
    """
    Publicly accessible item detail. 
    Hides seller contact info and prompts registration.
    """
    item = get_object_or_404(Item, pk=pk)
    
    # We pass CATEGORY_CHOICES here too if you need to display 
    # the pretty name of the category in the detail view
    context = {
        'item': item
    }
    return render(request, 'listings/public_item_detail.html', context)

def contact_submit(request):
    if request.method == "POST":
        name = request.POST.get('name')
        email = request.POST.get('email')
        subject = request.POST.get('subject')
        message = request.POST.get('message')

        # This will show up in your VS Code terminal / CMD
        print(f"\n--- NEW CONTACT FORM SUBMISSION ---")
        print(f"From: {name} ({email})")
        print(f"Subject: {subject}")
        print(f"Message: {message}")
        print(f"------------------------------------\n")

        # Redirect back to the landing page (named 'index' in urls.py)
        return redirect('index')
    
    return redirect('index')

def live_chat_send(request):
    if request.method == "POST":
        try:
            data = json.loads(request.body)
            user_msg = data.get('message')
            
            if not user_msg:
                return JsonResponse({'status': 'error', 'message': 'Empty message'}, status=400)

            # 1. Identify or Create the Chat Session
            if request.user.is_authenticated:
                # Link to the logged-in user
                chat, created = SupportChat.objects.get_or_create(
                    user=request.user, 
                    is_resolved=False
                )
                sender_display = request.user.username
            else:
                # Link to the guest session
                if not request.session.session_key:
                    request.session.create()
                s_key = request.session.session_key
                chat, created = SupportChat.objects.get_or_create(
                    session_key=s_key, 
                    is_resolved=False
                )
                sender_display = f"Guest ({s_key[:6]})"

            # 2. Save the Message to listings_supportmessage
            SupportMessage.objects.create(
                chat=chat,
                sender_name=sender_display,
                text=user_msg,
                is_admin_reply=False
            )

            # 3. Print to Terminal for immediate monitoring
            print(f"\n💬 [LIVE CHAT] {sender_display}: {user_msg}")
            
            return JsonResponse({'status': 'sent'})
        
        except Exception as e:
            print(f"Error in live chat: {e}")
            return JsonResponse({'status': 'error'}, status=500)

    return JsonResponse({'status': 'invalid method'}, status=405)

# Restrict this view to Staff/Admins only
@user_passes_test(lambda u: u.is_staff)
def admin_chat_inbox(request):
    # Get all unresolved chats, newest first
    active_chats = SupportChat.objects.filter(is_resolved=False).order_by('-created_at')
    
    # If an ID is passed, get that specific chat's messages
    selected_chat_id = request.GET.get('chat_id')
    messages = []
    selected_chat = None
    
    if selected_chat_id:
        selected_chat = get_object_or_404(SupportChat, id=selected_chat_id)
        messages = selected_chat.messages.all().order_by('created_at')

    return render(request, 'listings/admin_inbox.html', {
        'active_chats': active_chats,
        'messages': messages,
        'selected_chat': selected_chat
    })

@user_passes_test(lambda u: u.is_staff)
def admin_reply(request, chat_id):
    if request.method == "POST":
        chat = get_object_or_404(SupportChat, id=chat_id)
        reply_text = request.POST.get('reply_text')
        
        if reply_text:
            SupportMessage.objects.create(
                chat=chat,
                sender_name="System Admin",
                text=reply_text,
                is_admin_reply=True
            )
            # Log to terminal so you see the full conversation flow
            print(f"📤 [ADMIN REPLY] to {chat.user or chat.session_key[:8]}: {reply_text}")

    # Using reverse ensures the redirect works even if your app is under /market/
    return redirect(f"{reverse('admin_inbox')}?chat_id={chat_id}")

@user_passes_test(lambda u: u.is_staff)
def resolve_chat(request, chat_id):
    """Mark a chat as resolved so it disappears from the active inbox."""
    chat = get_object_or_404(SupportChat, id=chat_id)
    chat.is_resolved = True
    chat.save()
    print(f"✅ [CHAT RESOLVED] Session: {chat.id}")
    return redirect('admin_inbox')

def get_new_messages(request):
    chat_id = request.GET.get('chat_id')
    last_id = request.GET.get('last_id', 0)
    
    # Fetch messages in this chat that the user hasn't seen yet
    new_msgs = SupportMessage.objects.filter(
        chat_id=chat_id, 
        id__gt=last_id
    ).order_by('created_at')
    
    results = []
    for m in new_msgs:
        results.append({
            'id': m.id,
            'text': m.text,
            'is_admin': m.is_admin_reply,
            'sender': m.sender_name
        })
        
    return JsonResponse({'messages': results})

def get_shipping_options(request, item_id):
    item = get_object_or_404(Item, id=item_id)
    
    # Constructing the v2 payload
    # Note: street_address and city are usually required for accurate v2 rates
    payload = {
        "origin": {
            "street_address": item.suburb, # Or seller's full address
            "city": item.city,
            "province": item.region,
            "postal_code": item.seller.postcode, 
            "country_code": "ZA"
        },
        "destination": {
            "street_address": request.POST.get('address'),
            "city": request.POST.get('city'),
            "province": request.POST.get('province'),
            "postal_code": request.POST.get('postcode'),
            "country_code": "ZA"
        },
        "parcels": [
            {
                "weight": 1.0, # You can pull this from your Item model
                "height": 10,
                "width": 10,
                "length": 10,
                "value": float(item.display_price)
            }
        ]
    }

    client = BobGoClient()
    response = client.get_checkout_rates(payload)
    
    # Bob Go v2 returns a list of rates
    rates = response.get('rates', [])
    
    return render(request, 'listings/shipping_selection.html', {
        'rates': rates,
        'item': item
    })
    
@login_required
def toggle_featured(request, pk):
    item = get_object_or_404(Item, pk=pk)
    # Security: Only the seller can feature their own item
    if item.seller != request.user:
        messages.error(request, "Unauthorized.")
        return redirect('my_listings')
    
    # Check if they are a vendor (only vendors can use this feature)
    if not hasattr(request.user, 'vendor_profile'):
        messages.error(request, "Only professional vendors can feature items.")
        return redirect('my_listings')

    # Toggle the boolean
    item.is_featured_on_profile = not item.is_featured_on_profile
    item.save()
    
    status = "featured" if item.is_featured_on_profile else "unfeatured"
    messages.success(request, f"Item has been {status} on your storefront.")
    return redirect('my_listings')