"""
Django settings for refind_market project.
Updated for modern pathing and static file resolution.
"""

import os
from pathlib import Path

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent


# Quick-start development settings - unsuitable for production
# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'django-insecure-*j!l@=v8l1f_#p8t4@&5bgqact+v5+sud3xo#m!tg%5c2wg)(y'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = ['lfwl134j-8000.uks1.devtunnels.ms','192.168.137.1','192.168.1.33', '127.0.0.1', '127.0.0.1', 'localhost','*','10.175.107.179']


# Application definition
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    
    # Your Apps
    'users',
    'listings',
    'orders',
]

# Tell Django to use your new User model
AUTH_USER_MODEL = 'users.User'

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'refind_market.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [BASE_DIR / 'templates'], 
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
                'listings.context_processors.unread_messages_count',
                'listings.context_processors.unread_requests_count',
                'listings.context_processors.accepted_purchases_count',
            ],
        },
    },
]

WSGI_APPLICATION = 'refind_market.wsgi.application'


# Database
# https://docs.djangoproject.com/en/5.2/ref/settings/#databases
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'refind_market',
        'USER': 'root',
        'PASSWORD': '13Sept2020@',
        'HOST': 'localhost',
        'PORT': '3306',
        'OPTIONS': {
            'init_command': "SET sql_mode='STRICT_TRANS_TABLES'",
        },
    }
}


# Password validation
AUTH_PASSWORD_VALIDATORS = [
    {'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator'},
    {'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator'},
    {'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator'},
    {'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator'},
]


# Internationalization
LANGUAGE_CODE = 'en-us'
TIME_ZONE = 'UTC'
USE_I18N = True
USE_TZ = True


# --- STATIC FILES (CSS, JavaScript, Images) ---
# https://docs.djangoproject.com/en/5.2/howto/static-files/
STATIC_URL = '/static/'

# This allows Django to find your logo in refind_market_root/listings/static/
STATICFILES_DIRS = [
    BASE_DIR / "static",
]

# This is where collectstatic will put files for deployment
STATIC_ROOT = BASE_DIR / "staticfiles"


# --- MEDIA FILES (Uploaded Images) ---
MEDIA_URL = '/media/'
MEDIA_ROOT = BASE_DIR / 'media'


# Default primary key field type
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

# Auth Redirects
LOGIN_URL = 'login'
LOGIN_REDIRECT_URL = 'item_list'
LOGOUT_REDIRECT_URL = 'item_list'

# Email Configuration
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'
DEFAULT_FROM_EMAIL = 'noreply@refindmarket.co.za'

BOBGO_API_KEY = '11f7a624c89c4e75af6d42835fb2a283'
BOBGO_BASE_URL = 'https://api.sandbox.bobgo.co.za/v2'