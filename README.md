# 🏓 Padel Shop - Flutter E-commerce App

A modern, feature-rich e-commerce mobile application built with Flutter for padel equipment and accessories. The app provides a seamless shopping experience with Firebase backend integration.

## 🚀 Features

### 🔐 Authentication
- **Firebase Authentication** with email/password
- **Google Sign-In** integration
- User registration with improved navigation flow
- Secure user session management

### 🏪 Product Catalog
- Browse padel rackets, balls, bags, and accessories
- **Product categories** and brand filtering
- **Search functionality** with keyword matching
- **Product details** with specifications
- **Image galleries** for products
- **Rating and review system**

### 🛒 Shopping Experience
- **Shopping cart** with quantity management
- **Wishlist/Favorites** functionality
- **Order placement** and checkout
- **Order history** with status tracking
- **User profile** management

### 🎨 UI/UX
- **Custom animated splash screen** with logo
- **Material Design 3** components
- **Responsive design** for different screen sizes
- **Dark/Light theme** support
- **Smooth navigation** with GoRouter

### 🔥 Firebase Integration
- **Firestore Database** for product and order data
- **Firebase Auth** for user authentication
- **Security Rules** for data protection
- **Composite indexes** for efficient queries

## 📱 Screenshots

*Add your app screenshots here*

## 🛠️ Tech Stack

### Frontend
- **Flutter 3.32.8** - UI framework
- **Dart 3.8.1** - Programming language
- **Riverpod** - State management
- **GoRouter** - Navigation and routing
- **Material Design 3** - UI components

### Backend
- **Firebase Auth** - Authentication service
- **Cloud Firestore** - NoSQL database
- **Firebase Security Rules** - Data access control

### Development Tools
- **VS Code** - IDE
- **Android Studio** - Android development
- **Firebase Console** - Backend management
- **Git** - Version control

## 📁 Project Structure

```
lib/
├── core/                    # Core utilities and shared code
│   ├── models/             # Data models (Order, Product, User)
│   ├── providers/          # Global providers (Auth, Theme)
│   ├── utils/              # Utility functions
│   └── widgets/            # Reusable widgets (SplashScreen)
├── features/               # Feature-based modules
│   ├── auth/              # Authentication (Login, Register)
│   ├── cart/              # Shopping cart functionality
│   ├── home/              # Home page and navigation
│   ├── orders/            # Order management and history
│   ├── product/           # Product catalog and details
│   ├── profile/           # User profile management
│   └── settings/          # App settings
├── config/                # App configuration
│   ├── localization/      # Internationalization
│   ├── routes/            # Route definitions
│   └── theme/             # Theme configuration
└── main.dart             # App entry point
```

## 🔧 Installation & Setup

### Prerequisites
- **Flutter SDK 3.32.8+**
- **Dart SDK 3.8.1+**
- **Android Studio** or **Xcode** for device testing
- **Firebase project** set up
- **Git** for version control

### 1. Clone Repository
```bash
git clone https://github.com/Ahmed2004401/the_Padel_shop.git
cd flutter_application_1
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Firebase Setup
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
2. Add Android/iOS apps to your project
3. Download and add configuration files:
   - `android/app/google-services.json` (Android)
   - `ios/Runner/GoogleService-Info.plist` (iOS)
4. Enable Authentication and Firestore Database

### 4. Enable Developer Mode (Windows)
```bash
start ms-settings:developers
```
Turn ON Developer Mode for symlink support.

### 5. Run the App
```bash
flutter run
```

## 🔥 Firebase Configuration

### Firestore Collections
The app uses the following Firestore collections:
- `users` - User profiles and preferences
- `products` - Product catalog
- `orders` - Order history and tracking
- `carts` - Shopping cart data
- `categories` - Product categories
- `brands` - Product brands
- `reviews` - Product reviews
- `coupons` - Discount coupons
- `analytics` - App usage analytics

### Required Firestore Indexes
Create these composite indexes for optimal performance:

**Orders Collection:**
```
userId (Ascending) + createdAt (Descending)
userId (Ascending) + status (Ascending) + createdAt (Descending)
```

**Products Collection:**
```
category (Ascending) + createdAt (Descending)
category (Ascending) + price (Ascending)
isActive (Ascending) + isFeatured (Descending) + createdAt (Descending)
```

### Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /products/{productId} {
      allow read: if true;
      allow write: if isAdmin();
    }
    match /orders/{orderId} {
      allow read, write: if request.auth != null && 
        (request.auth.uid == resource.data.userId || isAdmin());
    }
    // ... other rules
  }
}
```

## 📊 Database Schema

Detailed database schema is available in `docs/firebase_schema.md` with:
- Collection structures
- Field types and descriptions
- Security rules
- Index requirements
- Sample data formats

## 🏗️ Architecture

### State Management
- **Riverpod** for reactive state management
- **Provider pattern** for dependency injection
- **FutureProvider** for async data loading
- **StateProvider** for simple state

### Navigation
- **GoRouter** for declarative routing
- **Route-based** navigation structure
- **Authentication guards** for protected routes
- **Deep linking** support

### Error Handling
- Comprehensive error handling for Firebase operations
- User-friendly error messages
- Retry mechanisms for network operations
- Loading states and error boundaries

## 🧪 Testing

### Run Tests
```bash
flutter test
```

### Run Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

### Code Analysis
```bash
flutter analyze
```

## 📱 Build & Deployment

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🔧 Troubleshooting

### Common Issues

**1. Order History Not Loading**
- **Cause:** Missing Firestore composite index
- **Solution:** Create index: `userId (asc) + createdAt (desc)` in Firebase Console

**2. Build Fails on Windows**
- **Cause:** Developer Mode not enabled
- **Solution:** Enable Developer Mode in Windows Settings

**3. Firebase Connection Issues**
- **Cause:** Missing or incorrect configuration files
- **Solution:** Verify `google-services.json` and `GoogleService-Info.plist`

**4. Products Not Displaying**
- **Cause:** Empty Firestore collections
- **Solution:** Add sample data using Firebase Console or scripts

### Debug Commands
```bash
# Check Flutter environment
flutter doctor

# Clean build cache
flutter clean && flutter pub get

# Run with verbose logging
flutter run --verbose

# Check connected devices
flutter devices
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Ahmed Khalil**
- GitHub: [@Ahmed2004401](https://github.com/Ahmed2004401)
- Repository: [the_Padel_shop](https://github.com/Ahmed2004401/the_Padel_shop)

## 📞 Support

For support and questions:
1. Open an issue on GitHub
2. Check the [Firebase Documentation](https://firebase.google.com/docs)
3. Review [Flutter Documentation](https://docs.flutter.dev/)

## 🎯 Roadmap

### Upcoming Features
- [ ] **Payment Integration** (Stripe/PayPal)
- [ ] **Push Notifications** for order updates
- [ ] **Inventory Management** for stock tracking
- [ ] **Admin Dashboard** for store management
- [ ] **Multi-language Support** (Arabic, Spanish)
- [ ] **Offline Mode** with local caching
- [ ] **Social Login** (Facebook, Apple)
- [ ] **Product Recommendations** using ML

### Performance Optimizations
- [ ] **Image Caching** and lazy loading
- [ ] **Database Query** optimization
- [ ] **App Size** reduction
- [ ] **Memory Management** improvements

## 📈 Analytics & Monitoring

The app includes analytics tracking for:
- User engagement metrics
- Product view analytics
- Order completion rates
- App performance monitoring

---

## 🎉 Getting Started Quickly

1. **Clone** the repository
2. **Run** `flutter pub get`
3. **Enable** Windows Developer Mode
4. **Set up** Firebase project
5. **Create** Firestore indexes
6. **Run** `flutter run`

Your Padel Shop app should now be running! 🏓🚀

---

*Made with ❤️ using Flutter and Firebase*
