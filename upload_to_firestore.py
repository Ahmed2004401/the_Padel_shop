import openpyxl
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from datetime import datetime
import uuid

# Initialize Firebase
# Make sure you have your Firebase service account key file downloaded
# Download from: Firebase Console → Project Settings → Service Accounts → Generate New Private Key
try:
    cred = credentials.Certificate('firebase_key.json')
    firebase_admin.initialize_app(cred)
except Exception as e:
    print(f"Error initializing Firebase: {e}")
    print("Make sure you have 'firebase_key.json' in the project root.")
    print("Download it from: Firebase Console → Project Settings → Service Accounts")
    exit(1)

db = firestore.client()

# Load Excel file
excel_file = 'now integrate to  a full inventory.xlsx'
wb = openpyxl.load_workbook(excel_file)
ws = wb.active

# Parse data
rows = list(ws.iter_rows(values_only=True))
headers = rows[0]
data_rows = rows[1:]

print(f"Found {len(data_rows)} products to upload")
print(f"Headers: {headers}\n")

# Extract unique categories and brands
categories = set()
brands = set()
products = []

for idx, row in enumerate(data_rows):
    if not row[0]:  # Skip empty rows
        continue
    
    brand = row[0]
    category = row[1]
    product_name = row[2]
    player_profile = row[3]
    price_eur = row[4]
    stock = int(row[5]) if row[5] else 0
    
    brands.add(brand)
    categories.add(category)
    
    # Convert EUR to USD (approximate, you can adjust the rate)
    eur_to_usd = 1.10
    price_usd = round(float(price_eur) * eur_to_usd, 2) if price_eur else 0
    
    product_id = str(uuid.uuid4())[:12]  # Generate short UUID
    
    product = {
        'id': product_id,
        'name': product_name,
        'description': f"{brand} {product_name} - {player_profile}",
        'price': price_usd,
        'imageUrl': 'https://via.placeholder.com/200',  # Placeholder image
        'imageUrls': ['https://via.placeholder.com/200'],
        'category': category,
        'brand': brand,
        'rating': 4.5,  # Default rating
        'reviews': 0,
        'stock': stock,
        'createdAt': datetime.now(),
        'specifications': {
            'Type': player_profile,
            'Material': 'Carbon',
        }
    }
    
    products.append(product)

print(f"Unique categories: {sorted(categories)}")
print(f"Unique brands: {sorted(brands)}\n")

# Upload categories to Firestore
print("Uploading categories...")
for category in categories:
    db.collection('categories').document(category).set({
        'name': category,
        'createdAt': datetime.now()
    })
    print(f"  ✓ {category}")

# Upload products to Firestore
print(f"\nUploading {len(products)} products...")
batch = db.batch()
batch_count = 0

for product in products:
    doc_ref = db.collection('products').document(product['id'])
    batch.set(doc_ref, product)
    batch_count += 1
    
    # Firestore has a batch limit of 500 operations
    if batch_count % 100 == 0:
        batch.commit()
        print(f"  ✓ Uploaded {batch_count} products")
        batch = db.batch()

# Commit remaining products
if batch_count % 100 != 0:
    batch.commit()
    print(f"  ✓ Uploaded {len(products)} products total")

print("\n✅ Database population complete!")
print(f"   - {len(categories)} categories")
print(f"   - {len(products)} products")
print(f"   - {sum([p['stock'] for p in products])} total units in stock")
