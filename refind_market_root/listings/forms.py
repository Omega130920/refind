from django import forms
from .models import Item

class ItemCreateForm(forms.ModelForm):
    class Meta:
        model = Item
        fields = [
            'title', 'category', 'description', 'condition', 'negotiation_limit', # Added new fields here
            'price', 'total_quantity', 'show_on_marketplace', 
            'region', 'city', 'suburb',
            'image1', 'image2', 'image3', 'image4', 'image5', 'image6'
        ]
        widgets = {
            'title': forms.TextInput(attrs={'placeholder': 'e.g. iPhone 15 Pro Max'}),
            'category': forms.Select(),
            'description': forms.Textarea(attrs={'rows': 4, 'placeholder': 'Describe condition, age, flaws...'}),
            # Added widgets for new fields to ensure they render as dropdowns
            'condition': forms.Select(),
            'negotiation_limit': forms.Select(),
            'price': forms.NumberInput(attrs={'placeholder': '0.00', 'step': '0.01'}),
            'total_quantity': forms.NumberInput(attrs={'min': '1', 'placeholder': 'Quantity available'}),
            'region': forms.TextInput(attrs={'placeholder': 'e.g. Western Cape'}),
            'city': forms.TextInput(attrs={'placeholder': 'e.g. Cape Town'}),
            'suburb': forms.TextInput(attrs={'placeholder': 'e.g. Claremont'}),
            'show_on_marketplace': forms.CheckboxInput(attrs={'class': 'form-check-input'}),
        }
        labels = {
            'show_on_marketplace': 'List on Main Marketplace (Uncheck for Storefront Only)',
            'condition': 'Item Condition',
            'negotiation_limit': 'Social Negotiation Room'
        }

    def __init__(self, *args, **kwargs):
        self.user = kwargs.pop('user', None)
        super(ItemCreateForm, self).__init__(*args, **kwargs)

        if self.user and not hasattr(self.user, 'vendor_profile'):
            self.fields['show_on_marketplace'].widget = forms.HiddenInput()
            self.initial['show_on_marketplace'] = True 
        
    def clean_price(self):
        price = self.cleaned_data.get('price')
        if price and price <= 0:
            raise forms.ValidationError("Price must be greater than zero.")
        return price

    def clean_total_quantity(self):
        qty = self.cleaned_data.get('total_quantity')
        if qty is not None and qty < 1:
            raise forms.ValidationError("You must list at least 1 item.")
        return qty