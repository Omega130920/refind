from django.contrib import admin
from django.urls import path, include
from django.contrib.auth import views as auth_views
from django.conf import settings 
from django.conf.urls.static import static
from listings import views as listing_views # Import your listings views

urlpatterns = [
    path('admin/', admin.site.urls),
    
    # NEW LANDING PAGE (The Entry Point)
    path('', listing_views.landing_page, name='index'),
    
    # LOGIN / LOGOUT
    path('login/', auth_views.LoginView.as_view(template_name='users/login.html'), name='login'),
    path('logout/', auth_views.LogoutView.as_view(template_name='users/logout.html'), name='logout'),
    
    # APP URLS
    path('market/', include('listings.urls')),
    path('users/', include('users.urls')),
    path('orders/', include('orders.urls')),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)