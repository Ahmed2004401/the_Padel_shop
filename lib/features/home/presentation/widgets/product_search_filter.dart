import 'package:flutter/material.dart';

class ProductSearchFilter extends StatefulWidget {
  final Function(String query, String? selectedCategory, String? selectedBrand)
      onFilter;
  final List<String> categories;
  final List<String> brands;

  const ProductSearchFilter({
    required this.onFilter,
    required this.categories,
    required this.brands,
    super.key,
  });

  @override
  State<ProductSearchFilter> createState() => _ProductSearchFilterState();
}

class _ProductSearchFilterState extends State<ProductSearchFilter> {
  late TextEditingController _searchController;
  String? _selectedCategory;
  String? _selectedBrand;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilter() {
    widget.onFilter(_searchController.text, _selectedCategory, _selectedBrand);
  }

  void _clearFilter() {
    _searchController.clear();
    setState(() {
      _selectedCategory = null;
      _selectedBrand = null;
    });
    _applyFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _applyFilter();
                      },
                    )
                  : null,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onChanged: (_) => _applyFilter(),
          ),
          const SizedBox(height: 12),
          // Category filter
          DropdownButton<String>(
            isExpanded: true,
            value: _selectedCategory,
            hint: const Text('Filter by Category'),
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('All Categories'),
              ),
              ...widget.categories
                  .map((cat) => DropdownMenuItem<String>(
                        value: cat,
                        child: Text(cat),
                      ))
                  .toList(),
            ],
            onChanged: (value) {
              setState(() => _selectedCategory = value);
              _applyFilter();
            },
          ),
          const SizedBox(height: 8),
          // Brand filter
          DropdownButton<String>(
            isExpanded: true,
            value: _selectedBrand,
            hint: const Text('Filter by Brand'),
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('All Brands'),
              ),
              ...widget.brands
                  .map((brand) => DropdownMenuItem<String>(
                        value: brand,
                        child: Text(brand),
                      ))
                  .toList(),
            ],
            onChanged: (value) {
              setState(() => _selectedBrand = value);
              _applyFilter();
            },
          ),
          const SizedBox(height: 12),
          // Clear filters button
          ElevatedButton.icon(
            onPressed: _clearFilter,
            icon: const Icon(Icons.refresh),
            label: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }
}
