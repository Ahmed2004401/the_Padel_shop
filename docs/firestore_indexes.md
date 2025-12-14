# Firebase Firestore Indexes Configuration

## Required Composite Indexes for Padel Shop App

Add these indexes in your Firebase Console → Firestore Database → Indexes tab.

### 1. Orders Collection Indexes

#### Basic Orders Query (userId + createdAt)
```
Collection ID: orders
Fields indexed:
- userId: Ascending
- createdAt: Descending
Query scope: Collection
```

#### Orders with Status Filter (userId + status + createdAt)  
```
Collection ID: orders
Fields indexed:
- userId: Ascending  
- status: Ascending
- createdAt: Descending
Query scope: Collection
```

#### Orders Date Range Query (userId + createdAt range)
```
Collection ID: orders
Fields indexed:
- userId: Ascending
- createdAt: Ascending
Query scope: Collection
```

### 2. Products Collection Indexes

#### Products by Category
```
Collection ID: products
Fields indexed:
- category: Ascending
- createdAt: Descending
Query scope: Collection
```

#### Products by Category and Price
```
Collection ID: products
Fields indexed:
- category: Ascending
- price: Ascending
Query scope: Collection
```

#### Products by Category and Rating
```
Collection ID: products
Fields indexed:
- category: Ascending
- rating: Descending
Query scope: Collection
```

#### Products by Brand
```
Collection ID: products
Fields indexed:
- brand: Ascending
- createdAt: Descending
Query scope: Collection
```

#### Featured Products
```
Collection ID: products
Fields indexed:
- isActive: Ascending
- isFeatured: Descending
- createdAt: Descending
Query scope: Collection
```

#### Product Search
```
Collection ID: products
Fields indexed:
- searchKeywords: Array-contains
- createdAt: Descending
Query scope: Collection
```

### 3. Reviews Collection Indexes

#### Reviews by Product
```
Collection ID: reviews
Fields indexed:
- productId: Ascending
- createdAt: Descending
Query scope: Collection
```

#### Reviews by Product and Rating
```
Collection ID: reviews
Fields indexed:
- productId: Ascending
- rating: Descending
Query scope: Collection
```

#### Reviews by User
```
Collection ID: reviews
Fields indexed:
- userId: Ascending
- createdAt: Descending
Query scope: Collection
```

## How to Add Indexes in Firebase Console

### Method 1: Firebase Console (Recommended)
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Navigate to **Firestore Database**
4. Click on **Indexes** tab
5. Click **Create Index**
6. Fill in the details for each index above
7. Click **Create**

### Method 2: Using Firebase CLI
```bash
# Install Firebase CLI if not already installed
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firestore in your project
firebase init firestore

# Deploy indexes (after creating firestore.indexes.json)
firebase deploy --only firestore:indexes
```

### Method 3: Auto-generated from Error Links
When you run your app and get the "query requires an index" error:
1. Copy the URL from the error message
2. Open it in your browser
3. Click "Create Index" 
4. Wait for the index to build (usually 1-2 minutes)

## firestore.indexes.json (Optional - for CLI deployment)

Create this file in your project root if you want to manage indexes via CLI:

```json
{
  "indexes": [
    {
      "collectionGroup": "orders",
      "queryScope": "COLLECTION",
      "fields": [
        {"fieldPath": "userId", "order": "ASCENDING"},
        {"fieldPath": "createdAt", "order": "DESCENDING"}
      ]
    },
    {
      "collectionGroup": "orders", 
      "queryScope": "COLLECTION",
      "fields": [
        {"fieldPath": "userId", "order": "ASCENDING"},
        {"fieldPath": "status", "order": "ASCENDING"}, 
        {"fieldPath": "createdAt", "order": "DESCENDING"}
      ]
    },
    {
      "collectionGroup": "products",
      "queryScope": "COLLECTION", 
      "fields": [
        {"fieldPath": "category", "order": "ASCENDING"},
        {"fieldPath": "createdAt", "order": "DESCENDING"}
      ]
    },
    {
      "collectionGroup": "products",
      "queryScope": "COLLECTION",
      "fields": [
        {"fieldPath": "category", "order": "ASCENDING"},
        {"fieldPath": "price", "order": "ASCENDING"}
      ]
    },
    {
      "collectionGroup": "products", 
      "queryScope": "COLLECTION",
      "fields": [
        {"fieldPath": "isActive", "order": "ASCENDING"},
        {"fieldPath": "isFeatured", "order": "DESCENDING"},
        {"fieldPath": "createdAt", "order": "DESCENDING"}
      ]
    },
    {
      "collectionGroup": "reviews",
      "queryScope": "COLLECTION",
      "fields": [
        {"fieldPath": "productId", "order": "ASCENDING"},
        {"fieldPath": "createdAt", "order": "DESCENDING"}
      ]
    }
  ],
  "fieldOverrides": []
}
```

## Index Building Time

- **Small collections** (< 1000 docs): 1-2 minutes
- **Medium collections** (1K-100K docs): 5-15 minutes  
- **Large collections** (100K+ docs): 30+ minutes

## Testing Your Indexes

After creating the indexes, test your queries:

```javascript
// This should work after the userId + createdAt index is built
db.collection('orders')
  .where('userId', '==', 'user123')
  .orderBy('createdAt', 'desc')
  .limit(20)
  .get()
```

## Common Index Patterns

- **Filter + Sort**: userId (=) + createdAt (desc) 
- **Multiple Filters**: userId (=) + status (=) + createdAt (desc)
- **Range Queries**: userId (=) + createdAt (>=) + createdAt (<=)
- **Array Contains**: searchKeywords (array-contains) + createdAt (desc)

Your orders should appear once the `userId` + `createdAt` index is built! 🚀