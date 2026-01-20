from django.http import JsonResponse
from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.db.models import Avg
from django.utils import timezone

# Local app imports
from .forms import UserRegisterForm, UserUpdateForm
from listings.models import Item, Review
from orders.models import Order

from .forms import VendorApplyForm
from .models import Like, User, VendorProfile

from django.shortcuts import render, get_object_or_404

from django.core.mail import send_mail
from .models import VendorProfile, Follow

from django.db.models import Q

from .models import Post, Like, Comment

from django.db import connection

from django.db.models import Count, Q, F

import datetime

from datetime import timedelta
from django.utils import timezone

def register(request):
    if request.method == 'POST':
        form = UserRegisterForm(request.POST)
        id_number = request.POST.get('id_number') # Get ID from raw POST or form

        if form.is_valid():
            # 1. Perform SA ID Validation
            is_valid, id_data, error_msg = validate_and_decode_sa_id(id_number)
            
            if not is_valid:
                messages.error(request, f"ID Error: {error_msg}")
                return render(request, 'users/register.html', {'form': form})

            # 2. Check for existing ID in database to prevent multi-account scammers
            # Assuming 'id_number' is a field in your User model or Profile
            if User.objects.filter(id_number=id_number).exists():
                messages.error(request, "This ID number is already registered.")
                return render(request, 'users/register.html', {'form': form})

            # 3. Create the user object but don't save yet
            user = form.save(commit=False)
            
            # 4. Auto-populate decoded data
            user.id_number = id_number
            user.date_of_birth = id_data['dob']
            user.gender = id_data['gender']
            user.is_id_verified = True  # Tag them as mathematically verified
            
            # 5. Update T&C fields
            user.terms_accepted = True
            user.terms_accepted_date = timezone.now()
            
            # 6. Final Save
            user.save()
            
            username = form.cleaned_data.get('username')
            messages.success(request, f'Account verified and created for {username}!')
            
            print(f"🛡️ [SECURITY] {username} registered with valid SA ID {id_number}")
            return redirect('login')
    else:
        form = UserRegisterForm()
    
    return render(request, 'users/register.html', {'form': form})

@login_required
def profile(request):
    # Calculate average rating for the logged-in user
    avg_rating = Review.objects.filter(target_user=request.user).aggregate(Avg('rating'))['rating__avg']
    
    # If no reviews yet, default to 0
    rating_value = round(avg_rating, 1) if avg_rating else 0
    
    context = {
        'user': request.user,
        'rating_value': rating_value,
        # Items this user is selling that aren't sold yet
        'active_ads_count': Item.objects.filter(seller=request.user, is_sold=False).count(),
        # Items this user has successfully bought
        'purchases_count': Order.objects.filter(buyer=request.user, status='paid').count(),
    }
    return render(request, 'users/profile.html', context)

@login_required
def profile_update(request):
    if request.method == 'POST':
        form = UserUpdateForm(request.POST, instance=request.user)
        if form.is_valid():
            form.save()
            messages.success(request, 'Your profile has been updated!')
            return redirect('profile')
    else:
        form = UserUpdateForm(instance=request.user)
    
    return render(request, 'users/profile_update.html', {'form': form})

@login_required
def become_vendor(request):
    # Check if they already have a vendor profile
    if hasattr(request.user, 'vendor_profile'):
        messages.info(request, "You already have a vendor storefront!")
        return redirect('my_listings')

    if request.method == 'POST':
        form = VendorApplyForm(request.POST, request.FILES)
        if form.is_valid():
            # 1. Update the User's location data first
            user = request.user
            user.region = form.cleaned_data.get('region')
            user.city = form.cleaned_data.get('city')
            user.suburb = form.cleaned_data.get('suburb')
            user.save()

            # 2. Create the Vendor Profile
            vendor_profile = form.save(commit=False)
            vendor_profile.user = user
            # We also set the primary_market to the city as a default 
            # if you aren't capturing it separately yet
            vendor_profile.primary_market = user.city 
            vendor_profile.save()
            
            messages.success(request, f"Welcome to the family, {vendor_profile.business_name}! Your storefront is now active.")
            return redirect('vendor_storefront', store_slug=vendor_profile.store_slug)
    else:
        # Pre-fill the form with the user's current location if they have it
        form = VendorApplyForm(initial={
            'region': request.user.region,
            'city': request.user.city,
            'suburb': request.user.suburb
        })

    return render(request, 'users/become_vendor.html', {'form': form})

def vendor_storefront(request, store_slug):
    vendor = get_object_or_404(VendorProfile, store_slug=store_slug)
    
    # Base query for all active items by this seller
    all_items = Item.objects.filter(
        seller=vendor.user, 
        is_sold=False
    ).prefetch_related('images')

    # Get filter parameters
    query = request.GET.get('q')
    category = request.GET.get('category')
    max_price = request.GET.get('max_price')

    if query:
        all_items = all_items.filter(Q(title__icontains=query) | Q(description__icontains=query))
    if category:
        all_items = all_items.filter(category__icontains=category)
    if max_price:
        try:
            # Match marketplace price logic: remove 7.5% markup to check against DB price
            max_base_price = float(max_price) / 1.075
            all_items = all_items.filter(price__lte=max_base_price)
        except ValueError:
            pass

    # Separate into featured and others
    featured_items = all_items.filter(is_featured_on_profile=True)
    other_items = all_items.filter(is_featured_on_profile=False)

    return render(request, 'users/vendor_storefront.html', {
        'vendor': vendor,
        'featured_items': featured_items,
        'other_items': other_items,
        'query': query,
        'category': category,
        'max_price': max_price
    })
    
# --- HELPER: NOTIFY FOLLOWERS ---
def notify_followers(vendor, item, action_type="new"):
    """
    Simulates email/terminal notifications for followers.
    """
    follows = vendor.followers.all() 
    
    if action_type == "new":
        subject = f"✨ New Stock: {vendor.business_name}"
        message = f"{vendor.business_name} just listed: {item.title}. Check it out!"
    else:
        subject = f"🔄 Restock Alert: {vendor.business_name}"
        message = f"Good news! '{item.title}' has been restocked ({item.available_stock} available)."

    for follow in follows:
        send_mail(
            subject,
            message,
            'notifications@refindmarket.co.za',
            [follow.follower.email],
            fail_silently=False,
        )
        print(f"TERMINAL: Notified {follow.follower.username} about {vendor.business_name}")

# --- TOGGLE FOLLOW ---
@login_required
def toggle_follow(request, vendor_id):
    vendor = get_object_or_404(VendorProfile, id=vendor_id)
    if vendor.user == request.user:
        return redirect('vendor_storefront', store_slug=vendor.store_slug)

    follow_qs = Follow.objects.filter(follower=request.user, vendor=vendor)
    if follow_qs.exists():
        follow_qs.delete()
    else:
        Follow.objects.create(follower=request.user, vendor=vendor)
    
    return redirect('vendor_storefront', store_slug=vendor.store_slug)

def vendor_list(request):
    # Annotate with a distinct count of available items only
    vendors = VendorProfile.objects.all().annotate(
        active_stock_count=Count(
            'user__item', 
            filter=Q(user__item__is_sold=False) & Q(user__item__total_quantity__gt=F('user__item__quantity_sold')),
            distinct=True 
        )
    ).select_related('user').order_by('business_name')
    
    # Get search parameters
    query = request.GET.get('q')
    location_query = request.GET.get('location')

    # Filter by keyword (Name, Bio, or Items)
    if query:
        vendors = vendors.filter(
            Q(business_name__icontains=query) |
            Q(bio__icontains=query) |
            Q(user__item__category__icontains=query) |
            Q(user__item__title__icontains=query)
        ).distinct()

    # Filter by location (Suburb, City, or Region)
    if location_query:
        vendors = vendors.filter(
            Q(user__suburb__icontains=location_query) |
            Q(user__city__icontains=location_query) |
            Q(user__region__icontains=location_query)
        ).distinct()

    return render(request, 'users/vendor_list.html', {
        'vendors': vendors,
        'query': query,
        'location_query': location_query # Pass this back to keep the input filled
    })
    
# --- TIMELINE FEED ---
def timeline_feed(request):
    """Fetches all posts and displays them on the Town Square."""
    posts = Post.objects.all().order_by('-created_at')
    
    context = {
        'posts': posts,
    }
    return render(request, 'timeline/feed.html', context)

# --- CREATE POST ---
@login_required
def create_post(request):
    """Allows vendors and users to post updates and tag marketplace items."""
    if request.method == 'POST':
        content = request.POST.get('content')
        image = request.FILES.get('image')
        tagged_item_id = request.POST.get('tagged_item')

        # Using standard ORM since Post table structure is straightforward
        post = Post(
            author=request.user,
            content=content,
            image=image
        )
        if tagged_item_id:
            post.tagged_item_id = tagged_item_id
        
        post.save()
        return redirect('timeline_feed')

    # Fetch user's listings to populate the 'Tag Item' dropdown
    user_listings = Item.objects.filter(seller=request.user)
    
    return render(request, 'timeline/create_post.html', {
        'user_listings': user_listings
    })

@login_required
def toggle_like_post(request, post_id):
    if request.method == 'POST':
        with connection.cursor() as cursor:
            cursor.execute("SELECT id FROM timeline_post_likes WHERE post_id = %s AND user_id = %s", [post_id, request.user.id])
            row = cursor.fetchone()
            if row: cursor.execute("DELETE FROM timeline_post_likes WHERE id = %s", [row[0]])
            else: cursor.execute("INSERT INTO timeline_post_likes (post_id, user_id) VALUES (%s, %s)", [post_id, request.user.id])
    
    # Logic: Redirect to the current page + the specific post ID
    return redirect(request.META.get('HTTP_REFERER', 'timeline_feed') + f'#post-{post_id}')

@login_required
def add_comment(request, post_id):
    if request.method == 'POST':
        text = request.POST.get('text')
        if text:
            with connection.cursor() as cursor:
                cursor.execute("INSERT INTO timeline_comments (post_id, author_id, text) VALUES (%s, %s, %s)", [post_id, request.user.id, text])
    
    # Logic: Jump back to the post where the comment was made
    return redirect(request.META.get('HTTP_REFERER', 'timeline_feed') + f'#post-{post_id}')

def timeline_feed(request):
    posts = Post.objects.all().order_by('-created_at')
    
    # 1. Get filter values from the URL
    u_query = request.GET.get('user')
    loc_query = request.GET.get('location')
    time_query = request.GET.get('time')

    # 2. Filter by User/Vendor
    if u_query:
        posts = posts.filter(author__username=u_query)

    # 3. Filter by Location (City or Suburb)
    if loc_query:
        posts = posts.filter(
            Q(author__city__icontains=loc_query) | 
            Q(author__suburb__icontains=loc_query)
        )

    # 4. Filter by Date Posted
    now = timezone.now()
    if time_query == 'hour':
        posts = posts.filter(created_at__gte=now - timedelta(hours=1))
    elif time_query == 'day':
        posts = posts.filter(created_at__gte=now - timedelta(days=1))
    elif time_query == 'week':
        posts = posts.filter(created_at__gte=now - timedelta(weeks=1))

    user_listings = []
    if request.user.is_authenticated:
        user_listings = Item.objects.filter(seller=request.user, is_sold=False)

    return render(request, 'timeline/feed.html', {
        'posts': posts,
        'user_listings': user_listings,
        'current_loc': loc_query,
        'current_time': time_query,
    })

# --- POST DETAIL (For "View All Comments") ---
def post_detail(request, post_id):
    post = get_object_or_404(Post, id=post_id)
    return render(request, 'timeline/post_detail.html', {'post': post})

# --- TOGGLE COMMENT LIKE ---
@login_required
def toggle_comment_like(request, comment_id):
    comment = get_object_or_404(Comment, id=comment_id)
    if request.user in comment.comment_likes.all():
        comment.comment_likes.remove(request.user)
    else:
        comment.comment_likes.add(request.user)
    
    # Logic: Jump back to the specific post containing this comment
    return redirect(request.META.get('HTTP_REFERER', 'timeline_feed') + f'#post-{comment.post.id}')

def validate_and_decode_sa_id(id_number):
    """
    Validates a South African ID using the Luhn Algorithm.
    Returns (is_valid, data_dict, error_message)
    """
    if not id_number or len(id_number) != 13 or not id_number.isdigit():
        return False, None, "ID must be exactly 13 digits."

    # --- Step 1: Luhn Checksum ---
    digits = [int(d) for d in id_number]
    odd_sum = sum(digits[-1::-2])
    even_sum = 0
    for d in digits[-2::-2]:
        d = d * 2
        even_sum += d if d < 10 else d - 9
    
    if (odd_sum + even_sum) % 10 != 0:
        return False, None, "Invalid ID number (Checksum failed)."

    # --- Step 2: Extract DOB and Gender ---
    try:
        yy = int(id_number[0:2])
        mm = int(id_number[2:4])
        dd = int(id_number[4:6])
        
        # Century logic: if YY > current year short, assume 1900s
        curr_yy = int(datetime.datetime.now().strftime("%y"))
        century = 2000 if yy <= curr_yy else 1900
        dob = datetime.date(century + yy, mm, dd)
        
        # Gender: 0000-4999 Female, 5000-9999 Male
        gender_code = int(id_number[6:10])
        gender = "Female" if gender_code < 5000 else "Male"
        
        return True, {'dob': dob, 'gender': gender}, None
    except ValueError:
        return False, None, "ID contains an invalid date."
    
def check_id_availability(request):
    id_number = request.GET.get('id_number', None)
    data = {
        'is_taken': User.objects.filter(id_number=id_number).exists()
    }
    return JsonResponse(data)

@login_required
def toggle_comment_like(request, comment_id):
    comment = get_object_or_404(Comment, id=comment_id)
    if request.user in comment.comment_likes.all():
        comment.comment_likes.remove(request.user)
    else:
        comment.comment_likes.add(request.user)
    return redirect('timeline_feed')