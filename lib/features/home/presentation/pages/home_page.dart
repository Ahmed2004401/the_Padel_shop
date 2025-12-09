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
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const DrawerHeader(
                child: Text('Sections', style: TextStyle(fontSize: 20)),
              ),
              Expanded(
                child: categories.when(
                  data: (cats) {
                    return ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        ...cats.map((cat) {
                          final isSelected = _selectedCategory == cat;
                          return ListTile(
                            title: Text(cat),
                            selected: isSelected,
                            onTap: () {
                              // update selected category and clear brand
                              setState(() {
                                _selectedCategory = cat;
                                _selectedBrand = null;
                              });
                              Navigator.of(context).pop();
                            },
                          );
                        }).toList(),
                        const Divider(),
                        if (_selectedCategory != null) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Text('Brands'),
                          ),
                          // Brands list
                          FutureBuilder<List<String>>(
                            future: ref.read(brandsProvider(_selectedCategory!).future),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(),
                                ));
                              }
                              final brands = snapshot.data ?? [];
                              if (brands.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text('No brands for this section'),
                                );
                              }
                              return Column(
                                children: brands.map((b) {
                                  final selected = _selectedBrand == b;
                                  return ListTile(
                                    title: Text(b),
                                    selected: selected,
                                    onTap: () {
                                      setState(() {
                                        _selectedBrand = b;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ],
                      ],
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, st) => const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Error loading sections'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Padel Shop'),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile page coming soon!')),
                );
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
              child: Builder(builder: (context) {
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${product.name} - Product detail page coming soon!'),
              ),
            );
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
