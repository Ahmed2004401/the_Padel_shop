# Firebase Firestore Schema for Padel Shop App

## Collections Overview

```
📦 Firestore Database
├── 👤 users/
│   └── {userId}
├── 🏪 products/
│   └── {productId}
├── 📦 orders/
│   └── {orderId}
├── 🛒 carts/
│   └── {userId}
├── 🏷️ categories/
│   └── {categoryId}
├── 🏢 brands/
│   └── {brandId}
├── ⭐ reviews/
│   └── {reviewId}
├── 🎫 coupons/
│   └── {couponId}
└── 📊 analytics/
    └── {analyticsId}
```

## 1. Users Collection (`users`)

```javascript
// Document ID: {userId} (Firebase Auth UID)
{
  "uid": "string",                    // Firebase Auth UID
  "email": "string",                  // User email
  "displayName": "string",            // Full name
  "photoURL": "string?",              // Profile picture URL
  "phoneNumber": "string?",           // Phone number
  "addresses": [                      // Shipping addresses
    {
      "id": "string",
      "name": "string",               // Address name (Home, Office, etc.)
      "fullName": "string",           // Recipient name
      "phoneNumber": "string",
      "addressLine1": "string",
      "addressLine2": "string?",
      "city": "string",
      "state": "string",
      "postalCode": "string",
      "country": "string",
      "isDefault": "boolean"
    }
  ],
  "preferences": {
    "language": "string",             // "en", "es", etc.
    "currency": "string",             // "USD", "EUR", etc.
    "notifications": {
      "email": "boolean",
      "push": "boolean",
      "sms": "boolean",
      "orderUpdates": "boolean",
      "promotions": "boolean"
    }
  },
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "lastLoginAt": "timestamp",
  "isActive": "boolean"
}
```

## 2. Products Collection (`products`)

```javascript
// Document ID: {productId} (auto-generated)
{
  "id": "string",                     // Product ID
  "name": "string",                   // Product name
  "description": "string",            // Product description
  "shortDescription": "string",       // Brief description for listings
  "price": "number",                  // Current price
  "originalPrice": "number?",         // Original price (if on sale)
  "currency": "string",               // "USD", "EUR", etc.
  "imageUrl": "string",               // Main product image
  "imageUrls": ["string"],            // Additional product images
  "category": "string",               // Category name
  "categoryId": "string",             // Reference to categories collection
  "brand": "string?",                 // Brand name
  "brandId": "string?",               // Reference to brands collection
  "rating": "number",                 // Average rating (0-5)
  "reviews": "number",                // Total number of reviews
  "stock": "number",                  // Available quantity
  "sku": "string",                    // Stock keeping unit
  "specifications": {                 // Product specifications
    "weight": "string?",              // e.g., "350g"
    "material": "string?",            // e.g., "Carbon Fiber"
    "shape": "string?",               // e.g., "Round", "Diamond"
    "balance": "string?",             // e.g., "High", "Medium", "Low"
    "thickness": "string?",           // e.g., "38mm"
    "surface": "string?",             // e.g., "Rough", "Smooth"
    "level": "string?"                // e.g., "Beginner", "Intermediate", "Advanced"
  },
  "dimensions": {
    "length": "number?",              // cm
    "width": "number?",               // cm
    "height": "number?",              // cm
    "weight": "number?"               // grams
  },
  "tags": ["string"],                 // Search tags
  "searchKeywords": ["string"],       // Lowercase search terms
  "isActive": "boolean",              // Product visibility
  "isFeatured": "boolean",            // Featured product
  "isOnSale": "boolean",              // Sale status
  "salePercentage": "number?",        // Discount percentage
  "saleStartDate": "timestamp?",      // Sale start
  "saleEndDate": "timestamp?",        // Sale end
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "createdBy": "string",              // Admin user ID
  "metaTitle": "string?",             // SEO title
  "metaDescription": "string?"        // SEO description
}
```

## 3. Orders Collection (`orders`)

```javascript
// Document ID: {orderId} (auto-generated)
{
  "id": "string",                     // Order ID
  "orderNumber": "string",            // Human-readable order number
  "userId": "string",                 // Customer user ID
  "status": "string",                 // "processing", "shipped", "delivered", "cancelled"
  "items": [                          // Order items
    {
      "productId": "string",
      "name": "string",
      "imageUrl": "string",
      "brand": "string?",
      "price": "number",              // Price at time of purchase
      "quantity": "number",
      "subtotal": "number"            // price * quantity
    }
  ],
  "totals": {
    "subtotal": "number",             // Sum of all items
    "shipping": "number",             // Shipping cost
    "tax": "number",                  // Tax amount
    "discount": "number",             // Discount amount
    "total": "number"                 // Final total
  },
  "shippingAddress": {
    "fullName": "string",
    "phoneNumber": "string",
    "addressLine1": "string",
    "addressLine2": "string?",
    "city": "string",
    "state": "string",
    "postalCode": "string",
    "country": "string"
  },
  "billingAddress": {                 // Same structure as shippingAddress
    "fullName": "string",
    "phoneNumber": "string",
    "addressLine1": "string",
    "addressLine2": "string?",
    "city": "string",
    "state": "string",
    "postalCode": "string",
    "country": "string"
  },
  "payment": {
    "method": "string",               // "card", "paypal", "apple_pay", etc.
    "status": "string",               // "pending", "completed", "failed", "refunded"
    "transactionId": "string?",
    "paymentIntentId": "string?",     // Stripe payment intent
    "currency": "string"
  },
  "tracking": {
    "carrier": "string?",             // "UPS", "FedEx", "DHL", etc.
    "trackingNumber": "string?",
    "trackingUrl": "string?",
    "events": [
      {
        "label": "string",            // "Order confirmed", "Shipped", etc.
        "description": "string?",
        "timestamp": "timestamp",
        "location": "string?"
      }
    ]
  },
  "coupon": {
    "code": "string?",
    "discount": "number?",
    "type": "string?"                 // "percentage", "fixed"
  },
  "notes": "string?",                 // Customer notes
  "adminNotes": "string?",            // Internal notes
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "shippedAt": "timestamp?",
  "deliveredAt": "timestamp?",
  "estimatedDelivery": "timestamp?",
  "searchKeywords": ["string"]        // For admin search
}
```

## 4. Carts Collection (`carts`)

```javascript
// Document ID: {userId} (one cart per user)
{
  "userId": "string",                 // Cart owner
  "items": [
    {
      "productId": "string",
      "name": "string",
      "imageUrl": "string",
      "brand": "string?",
      "price": "number",              // Current price
      "quantity": "number",
      "addedAt": "timestamp"
    }
  ],
  "totals": {
    "subtotal": "number",
    "itemCount": "number"
  },
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "expiresAt": "timestamp"            // Auto-cleanup old carts
}
```

## 5. Categories Collection (`categories`)

```javascript
// Document ID: {categoryId} (auto-generated)
{
  "id": "string",
  "name": "string",                   // "Padel Rackets", "Balls", "Bags", etc.
  "slug": "string",                   // URL-friendly name
  "description": "string?",
  "imageUrl": "string?",              // Category image
  "iconUrl": "string?",               // Category icon
  "parentId": "string?",              // For subcategories
  "level": "number",                  // 0 for main categories, 1 for sub, etc.
  "sortOrder": "number",              // Display order
  "isActive": "boolean",
  "productCount": "number",           // Number of products in category
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "seoTitle": "string?",
  "seoDescription": "string?"
}
```

## 6. Brands Collection (`brands`)

```javascript
// Document ID: {brandId} (auto-generated)
{
  "id": "string",
  "name": "string",                   // "Wilson", "Babolat", "Head", etc.
  "slug": "string",                   // URL-friendly name
  "description": "string?",
  "logoUrl": "string?",               // Brand logo
  "websiteUrl": "string?",            // Brand website
  "country": "string?",               // Brand origin country
  "isActive": "boolean",
  "productCount": "number",
  "sortOrder": "number",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

## 7. Reviews Collection (`reviews`)

```javascript
// Document ID: {reviewId} (auto-generated)
{
  "id": "string",
  "productId": "string",              // Product being reviewed
  "userId": "string",                 // Reviewer
  "userName": "string",               // Reviewer display name
  "userAvatar": "string?",            // Reviewer photo
  "rating": "number",                 // 1-5 stars
  "title": "string?",                 // Review title
  "comment": "string",                // Review text
  "images": ["string"],               // Review photos
  "isVerifiedPurchase": "boolean",    // Purchased the product
  "orderItemId": "string?",           // Reference to order item
  "likes": "number",                  // Helpful votes
  "dislikes": "number",               // Not helpful votes
  "isApproved": "boolean",            // Moderation status
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "adminResponse": {
    "message": "string?",
    "respondedAt": "timestamp?",
    "respondedBy": "string?"
  }
}
```

## 8. Coupons Collection (`coupons`)

```javascript
// Document ID: {couponId} (auto-generated)
{
  "id": "string",
  "code": "string",                   // Coupon code (uppercase)
  "name": "string",                   // Internal name
  "description": "string?",           // Public description
  "type": "string",                   // "percentage", "fixed", "free_shipping"
  "value": "number",                  // Discount amount or percentage
  "minimumOrderAmount": "number?",    // Minimum order to use coupon
  "maximumDiscountAmount": "number?", // Max discount for percentage coupons
  "usageLimit": "number?",            // Total usage limit
  "usageCount": "number",             // Current usage count
  "userUsageLimit": "number?",        // Per-user usage limit
  "validFrom": "timestamp",
  "validUntil": "timestamp",
  "isActive": "boolean",
  "applicableCategories": ["string"], // Empty array = all categories
  "applicableProducts": ["string"],   // Empty array = all products
  "excludedCategories": ["string"],
  "excludedProducts": ["string"],
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "createdBy": "string"               // Admin user ID
}
```

## 9. Analytics Collection (`analytics`)

```javascript
// Document ID: date string (YYYY-MM-DD) for daily stats
{
  "date": "string",                   // YYYY-MM-DD
  "stats": {
    "pageViews": "number",
    "uniqueVisitors": "number",
    "newUsers": "number",
    "orders": "number",
    "revenue": "number",
    "averageOrderValue": "number",
    "topProducts": [
      {
        "productId": "string",
        "name": "string",
        "views": "number",
        "orders": "number"
      }
    ],
    "topCategories": [
      {
        "categoryId": "string",
        "name": "string",
        "views": "number"
      }
    ]
  },
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

## Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Products are publicly readable, admin writable
    match /products/{productId} {
      allow read: if true;
      allow write: if isAdmin();
    }
    
    // Orders - users can only see their own
    match /orders/{orderId} {
      allow read, write: if request.auth != null && 
        (request.auth.uid == resource.data.userId || isAdmin());
    }
    
    // Carts - users can only access their own
    match /carts/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Categories and brands are publicly readable
    match /categories/{categoryId} {
      allow read: if true;
      allow write: if isAdmin();
    }
    
    match /brands/{brandId} {
      allow read: if true;
      allow write: if isAdmin();
    }
    
    // Reviews - users can read all, write their own
    match /reviews/{reviewId} {
      allow read: if true;
      allow create: if request.auth != null && request.auth.uid == request.resource.data.userId;
      allow update: if request.auth != null && 
        (request.auth.uid == resource.data.userId || isAdmin());
      allow delete: if isAdmin();
    }
    
    // Coupons - publicly readable, admin writable
    match /coupons/{couponId} {
      allow read: if true;
      allow write: if isAdmin();
    }
    
    // Analytics - admin only
    match /analytics/{analyticsId} {
      allow read, write: if isAdmin();
    }
    
    // Helper function to check if user is admin
    function isAdmin() {
      return request.auth != null && 
        exists(/databases/$(database)/documents/users/$(request.auth.uid)) &&
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

## Indexes Needed

```javascript
// Composite indexes for efficient queries
// Products
products: [
  { category: "asc", createdAt: "desc" },
  { category: "asc", price: "asc" },
  { category: "asc", rating: "desc" },
  { brand: "asc", createdAt: "desc" },
  { isActive: "asc", isFeatured: "desc", createdAt: "desc" },
  { searchKeywords: "array-contains", createdAt: "desc" }
]

// Orders
orders: [
  { userId: "asc", createdAt: "desc" },
  { userId: "asc", status: "asc", createdAt: "desc" },
  { status: "asc", createdAt: "desc" }
]

// Reviews
reviews: [
  { productId: "asc", createdAt: "desc" },
  { productId: "asc", rating: "desc" },
  { userId: "asc", createdAt: "desc" }
]
```

This comprehensive schema provides the foundation for your Padel Shop app with proper data modeling, security rules, and indexing for optimal performance.