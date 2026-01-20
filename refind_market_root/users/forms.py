from django import forms
from django.contrib.auth.forms import UserCreationForm
from django.core.exceptions import ValidationError
from .models import User, VendorProfile
import datetime

class UserRegisterForm(UserCreationForm):
    email = forms.EmailField(required=True)
    first_name = forms.CharField(max_length=150, required=True)
    last_name = forms.CharField(max_length=150, required=True)
    
    # Verification Fields
    id_number = forms.CharField(
        max_length=13, 
        min_length=13, 
        label="SA ID Number",
        widget=forms.TextInput(attrs={
            'placeholder': 'Enter your 13-digit ID number', 
            'class': 'form-control',
            'maxlength': '13'
        })
    )
    
    # These are populated by JS and set to readonly/disabled in the UI
    date_of_birth = forms.DateField(
        label="Date of Birth",
        widget=forms.DateInput(attrs={
            'readonly': 'readonly', 
            'class': 'form-control', 
            'type': 'date'
        })
    )
    gender = forms.ChoiceField(
        choices=[('', '---'), ('Male', 'Male'), ('Female', 'Female')],
        label="Gender",
        widget=forms.Select(attrs={'class': 'form-control'})
    )
    
    phone_number = forms.CharField(max_length=15, label="Phone Number")
    country = forms.CharField(max_length=100, initial="South Africa")
    region = forms.CharField(max_length=100, label="Province/Region")
    city = forms.CharField(max_length=100)
    suburb = forms.CharField(max_length=100)

    class Meta(UserCreationForm.Meta):
        model = User
        fields = UserCreationForm.Meta.fields + (
            'email', 'first_name', 'last_name', 
            'id_number', 'date_of_birth', 'gender',
            'phone_number', 'country', 'region', 'city', 'suburb'
        )

    def clean_id_number(self):
        id_num = self.cleaned_data.get('id_number')
        
        # 1. Basic length and numeric check
        if not id_num.isdigit() or len(id_num) != 13:
            raise ValidationError("ID must be exactly 13 digits.")

        # 2. Luhn Algorithm Checksum (Mathematical Validity)
        digits = [int(d) for d in id_num]
        odd_sum = sum(digits[-1::-2])
        even_sum = 0
        for d in digits[-2::-2]:
            d = d * 2
            even_sum += d if d < 10 else d - 9
        
        if (odd_sum + even_sum) % 10 != 0:
            raise ValidationError("Invalid ID number checksum. Please enter a valid SA ID.")

        # 3. Duplicate Check (Block account reuse)
        if User.objects.filter(id_number=id_num).exists():
            raise ValidationError("This ID number is already registered.")

        return id_num

    def clean(self):
        cleaned_data = super().clean()
        id_num = cleaned_data.get('id_number')
        dob = cleaned_data.get('date_of_birth')
        gender = cleaned_data.get('gender')
        
        if id_num and len(id_num) == 13:
            # --- 1. SERVER-SIDE AGE VERIFICATION (18+) ---
            try:
                year_part = int(id_num[0:2])
                month_part = int(id_num[2:4])
                day_part = int(id_num[4:6])
                
                # Century Logic
                current_year = datetime.date.today().year
                century = 2000 if year_part <= (current_year % 100) else 1900
                full_birth_year = century + year_part
                
                birth_date = datetime.date(full_birth_year, month_part, day_part)
                today = datetime.date.today()
                age = today.year - birth_date.year - ((today.month, today.day) < (birth_date.month, birth_date.day))
                
                if age < 18:
                    self.add_error('id_number', "Legal Requirement: You must be 18 or older to trade on Re-Find.")
            except ValueError:
                self.add_error('id_number', "The date encoded in this ID is invalid.")

            # --- 2. GENDER CROSS-VERIFICATION ---
            # Digits 7-10: 0000-4999 Female, 5000-9999 Male
            gender_digit = int(id_num[6:10])
            expected_gender = "Female" if gender_digit < 5000 else "Male"
            if gender and gender != expected_gender:
                self.add_error('gender', "Gender selection does not match the provided ID number.")

        return cleaned_data

class UserUpdateForm(forms.ModelForm):
    class Meta:
        model = User
        fields = ['first_name', 'last_name', 'email', 'phone_number', 
                  'country', 'region', 'city', 'suburb']
        
        widgets = {
            'first_name': forms.TextInput(attrs={'class': 'form-control'}),
            'last_name': forms.TextInput(attrs={'class': 'form-control'}),
            'email': forms.EmailInput(attrs={'class': 'form-control'}),
            'phone_number': forms.TextInput(attrs={'class': 'form-control'}),
            'country': forms.TextInput(attrs={'class': 'form-control'}),
            'region': forms.TextInput(attrs={'class': 'form-control'}),
            'city': forms.TextInput(attrs={'class': 'form-control'}),
            'suburb': forms.TextInput(attrs={'class': 'form-control'}),
        }
        
class VendorApplyForm(forms.ModelForm):
    # These fields live on the User model, but we add them here to capture them
    region = forms.CharField(max_length=100, label="Province / Region")
    city = forms.CharField(max_length=100, label="City")
    suburb = forms.CharField(max_length=100, label="Suburb")

    class Meta:
        model = VendorProfile
        fields = ['business_name', 'bio', 'years_trading', 'logo', 'banner']
        labels = {
            'business_name': 'Business Name',
            'bio': 'About Your Store',
            'years_trading': 'Years of Trading Experience',
            'logo': 'Store Logo (Circular)',
            'banner': 'Store Banner (Background)',
        }
        widgets = {
            'business_name': forms.TextInput(attrs={'placeholder': "e.g. Ouma's Vintage Market"}),
            'bio': forms.Textarea(attrs={'placeholder': 'Tell us how you started...', 'rows': 4}),
            'years_trading': forms.NumberInput(attrs={'placeholder': 'e.g. 5', 'min': '0'}),
        }

    def clean_business_name(self):
        name = self.cleaned_data.get('business_name')
        if len(name) < 3:
            raise forms.ValidationError("Your business name is too short.")
        return name