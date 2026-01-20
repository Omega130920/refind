# listings/context_processors.py
from .models import Message 
from orders.models import Order 

def unread_messages_count(request):
    if request.user.is_authenticated:
        count = Message.objects.filter(recipient=request.user, is_read=False).count()
        return {'unread_count': count}
    return {'unread_count': 0}

def unread_requests_count(request):
    if request.user.is_authenticated:
        # Count where current user is SELLER and needs to approve
        count = Order.objects.filter(
            seller=request.user, 
            status='pending_approval'
        ).count()
        return {'pending_requests_count': count}
    return {'pending_requests_count': 0}

def accepted_purchases_count(request):
    if request.user.is_authenticated:
        # Count where current user is BUYER and seller has accepted
        # This triggers the "Purchases" notification
        count = Order.objects.filter(
            buyer=request.user, 
            status='accepted'
        ).count()
        return {'accepted_purchases_count': count}
    return {'accepted_purchases_count': 0}