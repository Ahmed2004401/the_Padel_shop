import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/core/providers/product_provider.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';
import '../widgets/user_profile_widget.dart';
import '../widgets/product_card.dart';

/// Home screen displaying user profile and product listing.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // Local selection state for section (category) and brand.
  String? _selectedCategory;
  String? _selectedBrand;

  @override
  Widget build(BuildContext context) {
  final categories = ref.watch(categoriesProvider);
  final products = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: Drawer(
        child: Column(
          children: [
            // User header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFF1a237e), Colors.blue[900]!],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: ref.watch(userProvider).when(
                  data: (userData) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hello,',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        userData?.displayName ?? 'Guest',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  loading: () => const CircularProgressIndicator(color: Colors.white),
                  error: (_, __) => const Text('Guest', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.home_outlined),
                    title: const Text('Home'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('My Profile'),
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/profile');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.shopping_bag_outlined),
                    title: const Text('Your Orders'),
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to orders
                    },
                  ),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Shop by Category',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  categories.when(
                    data: (cats) => Column(
                      children: cats.map((cat) {
                        final isSelected = _selectedCategory == cat;
                        return ListTile(
                          leading: const Icon(Icons.category_outlined),
                          title: Text(cat),
                          selected: isSelected,
                          onTap: () {
                            setState(() {
                              _selectedCategory = cat;
                              _selectedBrand = null;
                            });
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.settings_outlined),
                    title: const Text('Settings'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('Help & Support'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            SafeArea(
              top: false,
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
                onTap: () => _handleLogout(context),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a237e),
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: Container(
          height: 40,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search Padel Shop',
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
              prefixIcon: const Icon(Icons.search, color: Colors.black54),
              suffixIcon: const Icon(Icons.camera_alt_outlined, color: Colors.black54),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
            onTap: () {
              // Navigate to search page
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart_outlined),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.orange[700],
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: const Text(
                      '0',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () => context.go('/cart'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(productsProvider);
          ref.invalidate(categoriesProvider);
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivery location banner
              Container(
                color: const Color(0xFF283593),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.white, size: 20),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Deliver to Customer - New York 10001',
                        style: TextStyle(color: Colors.grey[300], fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
                  ],
                ),
              ),

              // Premium delivery banner
              Container(
                width: double.infinity,
                color: Colors.blue[700],
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.purple[700]!, Colors.blue[700]!],
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: const Text(
                        'PREMIUM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'FREE One-Day Delivery on eligible items',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Category horizontal scroll
              categories.when(
                data: (cats) => Container(
                  height: 50,
                  color: Colors.white,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: cats.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return ChoiceChip(
                          label: const Text('All'),
                          selected: _selectedCategory == null,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = null;
                              _selectedBrand = null;
                            });
                          },
                          backgroundColor: Colors.grey[200],
                          selectedColor: Colors.orange[100],
                          labelStyle: TextStyle(
                            color: _selectedCategory == null ? Colors.orange[900] : Colors.black87,
                            fontWeight: _selectedCategory == null ? FontWeight.w600 : FontWeight.w400,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        );
                      }
                      final cat = cats[index - 1];
                      final isSelected = _selectedCategory == cat;
                      return ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = selected ? cat : null;
                            if (!selected) _selectedBrand = null;
                          });
                        },
                        backgroundColor: Colors.grey[200],
                        selectedColor: Colors.orange[100],
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.orange[900] : Colors.black87,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      );
                    },
                  ),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),

              const SizedBox(height: 8),

              // Featured banner
              Container(
                height: 180,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[400]!, Colors.purple[400]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 20,
                      top: 0,
                      bottom: 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'New Arrivals',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Latest Padel Equipment',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                            ),
                            child: const Text('Shop Now'),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 20,
                      top: 20,
                      bottom: 20,
                      child: Icon(
                        Icons.sports_tennis,
                        size: 100,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Products grid
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(builder: (context) {
                      // Decide which provider to use based on selectedCategory/brand
                      if (_selectedCategory != null) {
                        final params = <String, String?>{'category': _selectedCategory!, 'brand': _selectedBrand};
                        final filtered = ref.watch(productsByCategoryAndBrandProvider(params));
                        return filtered.when(
                          data: (filteredProducts) => _buildProductsGrid(filteredProducts, context),
                          loading: () => const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          error: (e, st) => Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 32),
                              child: Text('Error loading products: $e'),
                            ),
                          ),
                        );
                      }

                      return products.when(
                        data: (allProducts) => _buildProductsGrid(allProducts, context),
                        loading: () => const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        error: (error, st) => Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Text('Error loading products: $error'),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
  // end Scaffold
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              context.go('/cart');
            },
          ),
          PopupMenuButton<String>(
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('Profile'),
              ),
              const PopupMenuItem<String>(
                value: 'settings',
                child: Text('Settings'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
            onSelected: (value) {
              if (value == 'profile') {
                context.push('/profile');
              } else if (value == 'settings') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings coming soon!')),
                );
              } else if (value == 'logout') {
                _handleLogout(context);
              }
            },
          ),
        ],
      ),
=======
    );
  }
>>>>>>> 1fce4de683ccbf48141a68fd2a4369be6f5ecaa5
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User profile card
            const UserProfileWidget(),

            // Keep the horizontal category chips for quick filter, but drive from selectedCategoryProvider
            categories.when(
              data: (cats) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Categories',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            FilterChip(
                              label: const Text('All'),
                              selected: _selectedCategory == null,
                              onSelected: (selected) {
                                setState((){
                                  _selectedCategory = null;
                                  _selectedBrand = null;
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            ...cats.map((category) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text(category),
                                  selected: _selectedCategory == category,
                                  onSelected: (selected) {
                                    setState((){
                                      _selectedCategory = selected ? category : null;
                                      if (!selected) _selectedBrand = null;
                                    });
                                  },
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const SizedBox(
                height: 60,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, st) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Error loading categories: $error'),
              ),
            ),

            // Products grid
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Builder(builder: (context) {
                    // Decide which provider to use based on selectedCategory/brand
                    if (_selectedCategory != null) {
                      final params = <String, String?>{'category': _selectedCategory!, 'brand': _selectedBrand};
                      final filtered = ref.watch(productsByCategoryAndBrandProvider(params));
                      return filtered.when(
                        data: (filteredProducts) => _buildProductsGrid(filteredProducts, context),
                        loading: () => const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        error: (e, st) => Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Text('Error loading products: $e'),
                          ),
                        ),
                      );
                    }

                    return products.when(
                      data: (allProducts) => _buildProductsGrid(allProducts, context),
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (error, st) => Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Text('Error loading products: $error'),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsGrid(List filteredProducts, BuildContext context) {
    if (filteredProducts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            children: [
              Icon(
                Icons.shopping_basket,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No products found',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return ProductCard(
          product: product,
          onTap: () {
            // Navigate to product detail page
            context.push('/product/${product.id}', extra: product);
          },
        );
      },
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        // Call signOut directly from AuthService
        final authService = ref.read(authServiceProvider);
        await authService.signOut();
        
        // Small delay to allow state to update
        await Future.delayed(const Duration(milliseconds: 500));
        
        if (!mounted) return;
        // Navigate back to login - the AuthGuard will handle the redirection
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );
      } catch (e) {
        if (!mounted) return;
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
