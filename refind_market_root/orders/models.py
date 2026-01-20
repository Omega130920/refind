from django.db import models
from django.conf import settings
from listings.models import Item

class Order(models.Model):
    STATUS_CHOICES = [
        ('pending_approval', 'Waiting for Seller'),
        ('accepted', 'Accepted - Awaiting Shipping Details'),
        ('shipping_set', 'Shipping Set - Awaiting Payment'),
        ('declined', 'Declined'),
        ('paid', 'Paid'),
        ('shipped', 'Shipped'), # Added to match your generate_waybill logic
    ]

    item = models.ForeignKey(Item, on_delete=models.CASCADE)
    buyer = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='orders_bought')
    seller = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='orders_sold')
    
    # --- INVENTORY TRACKING ---
    quantity = models.PositiveIntegerField(default=1) 
    amount = models.DecimalField(max_digits=10, decimal_places=2) 
    
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending_approval')
    created_at = models.DateTimeField(auto_now_add=True)

    # --- SELLER COLLECTION FIELDS (From shipping_from.html) ---
    collection_street = models.CharField(max_length=255, blank=True, null=True)
    collection_city = models.CharField(max_length=100, blank=True, null=True)
    collection_suburb = models.CharField(max_length=100, blank=True, null=True)
    collection_postcode = models.CharField(max_length=10, blank=True, null=True)
    collection_province_code = models.CharField(max_length=10, default='GP') 

    # --- PARCEL DIMENSIONS ---
    parcel_weight = models.DecimalField(max_digits=5, decimal_places=2, default=1.0)
    parcel_length = models.IntegerField(default=10)
    parcel_width = models.IntegerField(default=10)
    parcel_height = models.IntegerField(default=10)

    # --- BUYER DELIVERY FIELDS (From shipping_to.html) ---
    delivery_street = models.CharField(max_length=255, blank=True, null=True)
    delivery_city = models.CharField(max_length=100, blank=True, null=True)
    delivery_postcode = models.CharField(max_length=10, blank=True, null=True)
    delivery_province_code = models.CharField(max_length=10, default='GP')
    
    # --- BOB GO DATA ---
    shipping_cost = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    bobgo_service_code = models.CharField(max_length=100, blank=True, null=True)
    bobgo_provider_slug = models.CharField(max_length=100, blank=True, null=True) # REQUIRED FIX
    bobgo_waybill = models.URLField(max_length=500, blank=True, null=True)
    tracking_number = models.CharField(max_length=100, blank=True, null=True)
    
    # --- SELLER PREFERENCE ---
    preferred_method = models.CharField(max_length=50, default='any')

    class Meta:
        managed = False
        db_table = 'orders_order'

    def __str__(self):
        return f"Order for {self.quantity}x {self.item.title} by {self.buyer.username}"

    @property
    def unit_price(self):
        if self.quantity > 0:
            return round(self.amount / self.quantity, 2)
        return 0

    @property
    def total_with_shipping(self):
        return self.amount + self.shipping_cost