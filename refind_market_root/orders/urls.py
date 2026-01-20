from django.urls import path
from . import views

urlpatterns = [
    path('checkout/<int:item_id>/', views.checkout, name='checkout'),
    path('my-purchases/', views.my_purchases, name='my_purchases'),
    path('finalize-payment/<int:order_id>/', views.finalize_payment, name='finalize_payment'),
    # This is the line that was missing
    path('shipping-from/<int:order_id>/', views.shipping_from, name='shipping_from'),
    
    # Let's add the other one now to avoid the next error
    path('shipping-to/<int:order_id>/', views.shipping_to, name='shipping_to'),
    
    # The AJAX helper for BobGo rates
    path('get-bobgo-rates/', views.get_bobgo_rates_ajax, name='get_bobgo_rates_ajax'),
    path('finalize-payment/<int:order_id>/', views.finalize_payment, name='finalize_payment'),
    path('generate-waybill/<int:order_id>/', views.generate_waybill, name='generate_waybill'),
]