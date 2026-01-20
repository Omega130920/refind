from django.urls import path
from . import views

urlpatterns = [
    # PUBLIC "LURE" ROUTES (No Login Required)
    path('explore/', views.public_marketplace, name='public_marketplace'),
    path('explore/item/<int:pk>/', views.public_item_detail, name='public_item_detail'),
    
    path('', views.item_list, name='item_list'),
    path('my-listings/', views.my_listings, name='my_listings'), # New Path
    path('item/new/', views.item_create, name='item_create'),
    path('item/<int:pk>/', views.item_detail, name='item_detail'),
    path('item/<int:pk>/edit/', views.item_edit, name='item_edit'),
    path('item/<int:pk>/delete/', views.item_delete, name='item_delete'),
    path('item/<int:item_id>/requests/', views.manage_requests, name='manage_requests'),
    path('inbox/', views.inbox, name='inbox'),
    path('chat/<int:item_id>/<int:recipient_id>/', views.chat, name='chat'),
    path('inbox/delete/<int:item_id>/<int:other_user_id>/', views.delete_conversation, name='delete_conversation'),
    path('seller/<int:user_id>/', views.seller_profile, name='seller_profile'),
    path('item/<int:item_id>/report/', views.report_item, name='report_item'),
    path('order/<int:order_id>/review/', views.leave_review, name='leave_review'),
    path('contact-submit/', views.contact_submit, name='contact_submit'), # Add this line
    path('live-chat-send/', views.live_chat_send, name='live_chat_send'),
    path('admin-inbox/', views.admin_chat_inbox, name='admin_inbox'),
    path('admin-reply/<int:chat_id>/', views.admin_reply, name='admin_reply'),
    path('get-new-messages/', views.get_new_messages, name='get_new_messages'),
    path('admin-resolve/<int:chat_id>/', views.resolve_chat, name='resolve_chat'),
    path('item/<int:pk>/toggle-featured/', views.toggle_featured, name='toggle_featured'),
]