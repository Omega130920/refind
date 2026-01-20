from django.contrib.auth.models import AbstractUser
from django.db import models
from django.conf import settings
from django.utils.text import slugify
from django.core.mail import send_mail

class User(AbstractUser):
    # Identity Fields (Scam Deterrent: unique=True blocks reuse of IDs)
    id_number = models.CharField(max_length=13, unique=True, blank=True, null=True, db_index=True)
    date_of_birth = models.DateField(null=True, blank=True)
    gender = models.CharField(max_length=10, blank=True, null=True)
    is_dha_verified = models.BooleanField(default=False)
    
    # Contact & Location
    phone_number = models.CharField(max_length=15, blank=True, null=True)
    country = models.CharField(max_length=100, default='South Africa')
    region = models.CharField(max_length=100, blank=True, null=True) # e.g., Western Cape
    city = models.CharField(max_length=100, blank=True, null=True)   # e.g., Cape Town
    suburb = models.CharField(max_length=100, blank=True, null=True) # e.g., Claremont
    
    # Legal Compliance
    terms_accepted = models.BooleanField(default=False)
    terms_accepted_date = models.DateTimeField(null=True, blank=True)

    class Meta:
        managed = False
        db_table = 'users_user'

    def __str__(self):
        return self.username
        
# --- NEW VENDOR PROFILE MODEL ---
class VendorProfile(models.Model):
    # Links this profile to a specific User
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL, 
        on_delete=models.CASCADE, 
        related_name='vendor_profile'
    )
    
    # Storefront Details
    business_name = models.CharField(max_length=255, unique=True)
    store_slug = models.SlugField(max_length=255, unique=True, blank=True)
    bio = models.TextField(blank=True, null=True) # Their "Origin Story"
    
    # Branding
    logo = models.ImageField(upload_to='vendor_logos/', blank=True, null=True)
    banner = models.ImageField(upload_to='vendor_banners/', blank=True, null=True)
    
    # Market Info (The Flea Market angle)
    primary_market = models.CharField(max_length=255, blank=True, null=True)
    years_trading = models.PositiveIntegerField(default=0)
    
    is_approved = models.BooleanField(default=False) 
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        managed = False  # Django will not manage migrations for this table
        db_table = 'users_vendorprofile'

    def save(self, *args, **kwargs):
        """Auto-generate slug from business name before saving"""
        if not self.store_slug and self.business_name:
            self.store_slug = slugify(self.business_name)
        super().save(*args, **kwargs)

    def __str__(self):
        return self.business_name
    
class Follow(models.Model):
    follower = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='following')
    vendor = models.ForeignKey(VendorProfile, on_delete=models.CASCADE, related_name='followers')
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        managed = False
        db_table = 'users_follow'
        unique_together = ('follower', 'vendor') # Prevents following twice

    def __str__(self):
        return f"{self.follower.username} follows {self.vendor.business_name}"
        
from django.db import models
from django.conf import settings

class Post(models.Model):
    author = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    content = models.TextField(max_length=1000)
    image = models.ImageField(upload_to='timeline_posts/', blank=True, null=True)
    video = models.FileField(upload_to='timeline_videos/', blank=True, null=True) # Add this
    tagged_item = models.ForeignKey('listings.Item', on_delete=models.SET_NULL, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    # We use a 'through' relationship to account for your 'id' column in the likes table
    likes = models.ManyToManyField(
        settings.AUTH_USER_MODEL, 
        related_name='liked_posts', 
        through='Like' 
    )

    class Meta:
        managed = False
        db_table = 'timeline_posts'
        ordering = ['-created_at']

class Like(models.Model):
    # This matches your timeline_post_likes table EXACTLY (id, post_id, user_id)
    post = models.ForeignKey(Post, on_delete=models.CASCADE)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)

    class Meta:
        managed = False
        db_table = 'timeline_post_likes'

class Comment(models.Model):
    post = models.ForeignKey(Post, on_delete=models.CASCADE, related_name='comments')
    author = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    text = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    # Add this relationship
    comment_likes = models.ManyToManyField(
        settings.AUTH_USER_MODEL, 
        related_name='liked_comments',
        through='CommentLike'
    )

    class Meta:
        managed = False
        db_table = 'timeline_comments'

class CommentLike(models.Model):
    comment = models.ForeignKey(Comment, on_delete=models.CASCADE)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)

    class Meta:
        managed = False
        db_table = 'timeline_comment_likes'