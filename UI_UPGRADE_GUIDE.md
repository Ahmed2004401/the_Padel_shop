# Padel Shop UI Upgrade Guide

## Overview
The home screen has been upgraded with a **Drawer-based Navigation System** that allows users to browse products by **Sections (Categories)** and then filter by **Brands** within each section.

## Features Added

### 1. **App Drawer**
- Accessible via the menu button (hamburger icon) in the AppBar
- Displays all available sections (categories): Paddles, Balls, Shoes, Accessories
- When a section is selected, a **Brands** submenu appears showing all brands available in that section
- Tap a brand to filter products by that brand

### 2. **Brand Support**
- Each product now has an optional `brand` field
- Brands are dynamically extracted from products in each section
- Users can select a brand to see only products from that brand

### 3. **Filtering**
- **Drawer-based filtering**: Select section → see brands → filter by brand
- **Quick category chips**: Horizontal filter chips still available below the profile card for fast category selection
- **Combined filtering**: When a section and brand are selected, the grid shows only products matching both criteria

### 4. **State Management**
- Selection state is managed locally in `HomeScreen` using:
  - `_selectedCategory`: Current selected section
  - `_selectedBrand`: Current selected brand within the section
- Uses Riverpod providers for data:
  - `productsProvider`: All products
  - `categoriesProvider`: All sections
  - `brandsProvider(category)`: Brands available in a category
  - `productsByCategoryAndBrandProvider(params)`: Filtered products

## File Changes

### Model Updates
- **`lib/core/models/product.dart`**:
  - Added optional `brand: String?` field to Product class
  - Updated `toMap()`, `fromMap()`, and `copyWith()` methods

### Provider Updates
- **`lib/core/providers/product_provider.dart`**:
  - Updated mock products with brand values (ProLine, MatchPro, GripX, StarterCo, BagMaster)
  - Added `brandsProvider(category)`: Returns list of brands for a category
  - Added `productsByCategoryAndBrandProvider(params)`: Filters products by category and brand

### UI Updates
- **`lib/features/home/presentation/pages/home_page.dart`**:
  - Added `Drawer` with hierarchical section/brand selection
  - Updated FilterChip row to use local state
  - Added `_buildProductsGrid()` helper method for reusable grid rendering
  - Products filter based on selected category/brand combination

## How to Add New Brands

1. **Add to Mock Products** (`lib/core/providers/product_provider.dart`):
   ```dart
   Product(
     id: '7',
     name: 'Premium Padel Racket',
     category: 'Paddles',
     brand: 'YourBrandName',  // ← Add or update this field
     // ... other fields
   ),
   ```

2. **Brands are automatically extracted** from products by category, so no additional configuration is needed.

## How to Add New Sections (Categories)

1. **Update Mock Products**:
   ```dart
   Product(
     id: '8',
     name: 'New Product',
     category: 'New Section Name',  // ← Creates new section
     brand: 'SomeBrand',
     // ... other fields
   ),
   ```

2. The new section will automatically appear in:
   - Drawer sections list
   - Category chips below profile card
   - Drawer brand submenu when selected

## User Experience Flow

1. User opens app → sees all products + profile card
2. User taps **menu icon** → Drawer opens
3. User selects **"Paddles"** → Drawer shows available paddle brands
4. User selects **"ProLine"** → Drawer closes, grid updates to show only ProLine paddles
5. User can also use quick chips below profile card for fast category changes
6. Selecting "All" clears filters and shows all products

## Future Enhancements

- [ ] Implement actual Firestore integration for products and brands
- [ ] Add brand logos/images to drawer
- [ ] Enable price filtering
- [ ] Add search functionality
- [ ] Implement brand detail pages
- [ ] Add brand sorting options

## Code Quality

- ✅ All code passes `flutter analyze` with no errors
- ✅ Uses ConsumerStatefulWidget for Riverpod integration
- ✅ Proper error handling with AsyncValue patterns
- ✅ Responsive layout with SingleChildScrollView
