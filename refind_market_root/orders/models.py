from django.db import models
from django.conf import settings
from decimal import Decimal
from listings.models import Item  # Ensure Item is imported

class Order(models.Model):
    STATUS_CHOICES = [
        ('pending_approval', 'Waiting for Seller'),
        ('accepted', 'Accepted - Awaiting Shipping Details'),
        ('shipping_set', 'Shipping Set - Awaiting Payment'),
        ('declined', 'Declined'),
        ('paid', 'Paid'),
        ('shipped', 'Shipped'),
        ('closed', 'Closed (Sold to someone else)'), # NEW: For ghost-free logic
    ]

    item = models.ForeignKey(Item, on_delete=models.CASCADE)
    buyer = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='orders_bought')
    seller = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='orders_sold')
    
    # --- INVENTORY & NEGOTIATION ---
    quantity = models.PositiveIntegerField(default=1) 
    
    # NEW FIELD: Stores the agreed BASE price (before the 7.5% fee)
    negotiated_base_price = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    
    # 'amount' will now act as the total product cost (Base + Fee)
    amount = models.DecimalField(max_digits=10, decimal_places=2) 
    
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending_approval')
    created_at = models.DateTimeField(auto_now_add=True)

    # --- SELLER COLLECTION FIELDS ---
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

    # --- BUYER DELIVERY FIELDS ---
    delivery_street = models.CharField(max_length=255, blank=True, null=True)
    delivery_city = models.CharField(max_length=100, blank=True, null=True)
    delivery_postcode = models.CharField(max_length=10, blank=True, null=True)
    delivery_province_code = models.CharField(max_length=10, default='GP')
    
    # --- BOB GO DATA ---
    shipping_cost = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    bobgo_service_code = models.CharField(max_length=100, blank=True, null=True)
    bobgo_provider_slug = models.CharField(max_length=100, blank=True, null=True)
    bobgo_waybill = models.URLField(max_length=500, blank=True, null=True)
    tracking_number = models.CharField(max_length=100, blank=True, null=True)
    
    preferred_method = models.CharField(max_length=50, default='any')

    class Meta:
        managed = False
        db_table = 'orders_order'

    def __str__(self):
        return f"Order for {self.quantity}x {self.item.title} by {self.buyer.username}"

    # --- UPDATED PROPERTY METHODS ---

    @property
    def platform_fee(self):
        """Returns the 7.5% fee based on the negotiated base price"""
        return round(float(self.negotiated_base_price) * 0.075, 2)

    @property
    def unit_price_with_fee(self):
        """Base price + 7.5% fee per item"""
        base = float(self.negotiated_base_price)
        return round(base + (base * 0.075), 2)

    @property
    def total_with_shipping(self):
        """Grand total for the buyer to pay"""
        return float(self.amount) + float(self.shipping_cost)