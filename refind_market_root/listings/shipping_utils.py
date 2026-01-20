import requests
import json
from django.conf import settings

class BobGoClient:
    def __init__(self):
        self.headers = {
            'Authorization': f'Bearer {settings.BOBGO_API_KEY}',
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        }
        # V2 Sandbox Base URL
        self.base_url = 'https://api.sandbox.bobgo.co.za/v2'

    def get_rates(self, payload):
        """
        POST /v2/rates
        Retrieves raw, real-time courier quotes.
        Used for the direct calculation between Seller and Buyer.
        """
        url = f"{self.base_url}/rates"
        try:
            response = requests.post(url, headers=self.headers, json=payload)
            print(f"DEBUG: BobGo /rates Status: {response.status_code}")
            
            if response.status_code != 200:
                print(f"DEBUG: Error Response: {response.text}")
                
            return response.json()
        except Exception as e:
            return {"error": str(e)}

    def get_checkout_rates(self, payload):
        """
        POST /v2/rates-at-checkout
        Retrieves customized rates based on business rules set in Bob Go dashboard.
        """
        url = f"{self.base_url}/rates-at-checkout"
        try:
            response = requests.post(url, headers=self.headers, json=payload)
            print(f"DEBUG: BobGo /rates-at-checkout Status: {response.status_code}")
            return response.json()
        except Exception as e:
            return {"error": str(e)}

    def create_order(self, order_payload):
        """
        POST /v2/orders
        Syncs the completed purchase to Bob Go for fulfillment/waybill generation.
        """
        url = f"{self.base_url}/orders"
        try:
            response = requests.post(url, headers=self.headers, json=order_payload)
            print(f"DEBUG: BobGo Order Sync Status: {response.status_code}")
            return response.json()
        except Exception as e:
            return {"error": str(e)}