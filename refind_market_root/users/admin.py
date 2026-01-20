from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import User

# Ensure you use the decorator OR the register function, not both.
@admin.register(User)
class CustomUserAdmin(UserAdmin):
    list_display = ('username', 'email', 'id_number', 'is_dha_verified', 'is_staff')
    fieldsets = UserAdmin.fieldsets + (
        ('Trust & Verification', {'fields': ('id_number', 'is_dha_verified', 'phone_number')}),
    )