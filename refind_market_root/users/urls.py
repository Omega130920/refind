from django.urls import path
from django.contrib.auth import views as auth_views
from . import views

urlpatterns = [
    # --- User & Vendor Management ---
    path('register/', views.register, name='register'),
    path('login/', auth_views.LoginView.as_view(template_name='users/login.html'), name='login'),
    path('logout/', auth_views.LogoutView.as_view(), name='logout'),
    path('profile/', views.profile, name='profile'),
    path('profile/edit/', views.profile_update, name='profile_update'),
    path('become-vendor/', views.become_vendor, name='become_vendor'),
    path('vendors/<slug:store_slug>/', views.vendor_storefront, name='vendor_storefront'),
    path('toggle-follow/<int:vendor_id>/', views.toggle_follow, name='toggle_follow'),
    path('directory/', views.vendor_list, name='vendor_list'),

    # --- Timeline (Social Hub) ---
    path('', views.timeline_feed, name='timeline_feed'), 
    path('create/', views.create_post, name='create_post'),
    
    # Corrected name to match your HTML {% url 'toggle_like_post' %}
    path('like/<int:post_id>/', views.toggle_like_post, name='toggle_like_post'),
    
    path('comment/<int:post_id>/', views.add_comment, name='add_comment'),
    path('comment/like/<int:comment_id>/', views.toggle_comment_like, name='toggle_comment_like'),
    
    # Path for the "View all comments" button
    path('post/<int:post_id>/', views.post_detail, name='post_detail'),

    # --- Utilities ---
    path('ajax/check-id/', views.check_id_availability, name='check_id_availability'),
]