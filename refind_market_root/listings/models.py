from django.db import models
from django.conf import settings
from django.utils import timezone
from datetime import timedelta
from users.models import User

class Item(models.Model):
    # Category Definitions
    CATEGORY_CHOICES = [
        ('Electronics', 'Electronics & Gadgets'),
        ('Computing', 'Laptops & Computers'),
        ('Mobile', 'Phones & Tablets'),
        ('Gaming', 'Video Games & Consoles'),
        ('Photography', 'Cameras & Optics'),
        ('Audio', 'Audio & Music Gear'),
        ('Fashion', 'Clothing & Apparel'),
        ('Watches', 'Luxury Watches & Jewelry'),
        ('Home', 'Furniture & Decor'),
        ('Appliances', 'Kitchen & Home Appliances'),
        ('Automotive', 'Vehicles & Car Parts'),
        ('Sporting', 'Sports & Fitness'),
        ('Tools', 'Tools & DIY'),
        ('Collectibles', 'Antiques & Collectibles'),
        ('Books', 'Books, Film & Hobbies'),
        ('Other', 'Other / Miscellaneous'),
    ]

    # 'seller' links to the 'id' in users_user
    seller = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.DO_NOTHING, db_column='seller_id')
    title = models.CharField(max_length=255)
    description = models.TextField(blank=True, null=True)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    category = models.CharField(max_length=100, choices=CATEGORY_CHOICES, blank=True, null=True)
    
    # is_sold acts as a manual toggle, but stock logic handles the rest
    is_sold = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    
    # --- NEW INVENTORY FIELDS ---
    total_quantity = models.PositiveIntegerField(default=1)
    quantity_sold = models.PositiveIntegerField(default=0)
    
    # NEW LOCATION FIELDS
    region = models.CharField(max_length=100, blank=True, null=True)
    city = models.CharField(max_length=100, blank=True, null=True)
    suburb = models.CharField(max_length=100, blank=True, null=True)

    # Images
    image = models.ImageField(upload_to='item_pics', default='default.jpg', blank=True, null=True)
    image1 = models.ImageField(upload_to='item_photos/', blank=True, null=True)
    image2 = models.ImageField(upload_to='item_photos/', blank=True, null=True)
    image3 = models.ImageField(upload_to='item_photos/', blank=True, null=True)
    image4 = models.ImageField(upload_to='item_photos/', blank=True, null=True)
    image5 = models.ImageField(upload_to='item_photos/', blank=True, null=True)
    image6 = models.ImageField(upload_to='item_photos/', blank=True, null=True)
    
    is_featured_on_profile = models.BooleanField(default=False)
    
    show_on_marketplace = models.BooleanField(default=True)

    class Meta:
        managed = False
        db_table = 'listings_item'

    def __str__(self):
        return self.title

    # --- PROPERTY METHODS ---

    @property
    def available_stock(self):
        """Calculates how many items are left"""
        stock = self.total_quantity - self.quantity_sold
        return max(0, stock)

    @property
    def is_available(self):
        """Item is available if not manually sold and stock > 0"""
        return not self.is_sold and self.available_stock > 0

    @property
    def is_new(self):
        """Returns True if the item was created in the last 24 hours"""
        return self.created_at >= timezone.now() - timedelta(hours=24)
    
    @property
    def display_price(self):
        """Returns the price shown to the buyer (Original + 7.5%)"""
        fee_multiplier = 1.075
        return round(float(self.price) * fee_multiplier, 2)

    @property
    def platform_fee(self):
        """Returns only the 7.5% portion for your profit tracking"""
        return round(float(self.price) * 0.075, 2)

    @property
    def location_display(self):
        """Returns a formatted location string for the UI"""
        parts = [self.suburb, self.city]
        return ", ".join([p for p in parts if p])
    
class Message(models.Model):
    item = models.ForeignKey(Item, on_delete=models.CASCADE)
    sender = models.ForeignKey(
        settings.AUTH_USER_MODEL, 
        on_delete=models.CASCADE, 
        related_name='sent_messages'
    )
    recipient = models.ForeignKey(
        settings.AUTH_USER_MODEL, 
        on_delete=models.CASCADE, 
        related_name='received_messages'
    )
    content = models.TextField()
    timestamp = models.DateTimeField(auto_now_add=True)
    is_read = models.BooleanField(default=False)

    class Meta:
        managed = False  # Tells Django NOT to manage this table
        db_table = 'listings_message'

    def __str__(self):
        return f"From {self.sender} to {self.recipient} re: {self.item.title}"
    
class Review(models.Model):
    order = models.OneToOneField('orders.Order', on_delete=models.CASCADE)
    reviewer = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='reviews_given')
    target_user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='reviews_received')
    rating = models.IntegerField() # We will limit this 1-5 in the form
    comment = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        managed = False
        db_table = 'listings_review'

    def __str__(self):
        return f"Rating for {self.target_user.username} - {self.rating} Stars"
    
class Report(models.Model):
    REASON_CHOICES = [
        ('Scam', 'Potential Scam or Fraud'),
        ('Prohibited', 'Prohibited/Illegal Item'),
        ('Duplicate', 'Duplicate Listing'),
        ('Misleading', 'Misleading Information'),
        ('Other', 'Other'),
    ]

    item = models.ForeignKey(Item, on_delete=models.CASCADE)
    reporter = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    reason = models.CharField(max_length=100, choices=REASON_CHOICES)
    description = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        managed = False
        db_table = 'listings_report'

    def __str__(self):
        return f"Report on {self.item.title} by {self.reporter.username}"
    
# --- NEW MODEL FOR MULTI-IMAGE GALLERY ---
class ItemImage(models.Model):
    # related_name='images' allows us to call item.images.all() in templates
    item = models.ForeignKey(Item, on_delete=models.CASCADE, related_name='images')
    image = models.ImageField(upload_to='item_photos/')

    class Meta:
        managed = False  # We want Django to create this specific table
        db_table = 'listings_itemimage'

    def __str__(self):
        return f"Image for {self.item.title}"
    
class SupportChat(models.Model):
    session_key = models.CharField(max_length=40, null=True, blank=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    is_resolved = models.BooleanField(default=False)

    class Meta:
        managed = False # Django won't create/alter this table
        db_table = 'listings_supportchat'

class SupportMessage(models.Model):
    chat = models.ForeignKey(SupportChat, on_delete=models.CASCADE, related_name='messages')
    sender_name = models.CharField(max_length=100)
    text = models.TextField()
    is_admin_reply = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        managed = False # Django won't create/alter this table
        db_table = 'listings_supportmessage'