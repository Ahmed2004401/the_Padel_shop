# Firebase Database Setup Instructions

## Step 1: Download Your Firebase Service Account Key

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project: **"the_Padel_shop"** (or your project name)
3. Click **⚙️ (Settings)** in the top-left corner
4. Go to **Service Accounts** tab
5. Click **Generate New Private Key** button
6. A JSON file will download automatically
7. **Rename it to `firebase_key.json`** and place it in the project root:
   ```
   c:\Users\asus\Documents\padel_app\flutter_application_1\firebase_key.json
   ```

## Step 2: Verify Firestore is Enabled

1. In Firebase Console, go to **Firestore Database**
2. Click **Create Database**
3. Choose **Start in test mode** (or production with rules)
4. Select your region (e.g., `us-central1`)
5. Click **Create**

## Step 3: Run the Upload Script

Once you have the `firebase_key.json` in place, run:

```powershell
cd "C:\Users\asus\Documents\padel_app\flutter_application_1"
C:/Users/asus/Documents/padel_app/flutter_application_1/.venv/Scripts/python.exe upload_to_firestore.py
```

## What Gets Uploaded

- **57 products** from the Excel file with:
  - Product name, brand, category, price (converted EUR→USD)
  - Stock quantities
  - Placeholder images (you can update later)
  - Specifications and player profile info
  
- **6 categories**: Racket, Overgrip, Ball, Bag, Shoe, Apparel

- **10+ brands**: Adidas, Bullpadel, Wilson, Head, Dunlop, etc.

## Notes

- Prices are converted from EUR to USD (1 EUR = 1.10 USD, adjustable)
- Placeholder images use `via.placeholder.com` (replace with real images)
- Default rating: 4.5 stars (you can adjust)
- All products are created on the current date/time

## Troubleshooting

If you get an error about `firebase_key.json` not found:
- Make sure the file is in the correct location
- Verify the filename is exactly `firebase_key.json`
- Check that Firebase is initialized in your Flutter app

If you get Firestore permission errors:
- Set Firestore rules to allow reads/writes (for testing):
  ```
  rules_version = '2';
  service cloud.firestore {
    match /databases/{database}/documents {
      match /{document=**} {
        allow read, write: if true;  // Test mode only
      }
    }
  }
  ```
