import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/services/cart_service.dart';
import 'package:flutter_application_1/core/models/cart_item.dart';

enum PaymentMethod { card, cod }

/// Simple Checkout page design.
/// - Shows order summary, shipping form, payment selection, promo code, totals
/// - Uses `CartService.instance` to retrieve cart items and totals
/// - This is a standalone page; integrate into your router or navigation when ready.
class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();

  // Shipping form controllers
  final _nameController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalController = TextEditingController();
  final _phoneController = TextEditingController();

  // Promo code
  final _promoController = TextEditingController();
  double _promoDiscount = 0.0; // 0 = none, otherwise fraction (e.g., 0.1 = 10%)

  // Payment method
  PaymentMethod _paymentMethod = PaymentMethod.card;

  // Defaults
  static const double shippingFeeDefault = 7.00;
  static const double taxRate = 0.10; // 10% tax for example

  // Helpers
  double _computeSubtotal(List<CartItem> items) {
    return items.fold(0.0, (sum, item) => sum + item.product.price * item.quantity);
  }

  void _applyPromo() {
    final code = _promoController.text.trim().toLowerCase();
    // Example: "padel10" -> 10% off; you can extend to real promo validation
    setState(() {
      if (code == 'padel10') {
        _promoDiscount = 0.10; // 10%
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Promo applied: 10% off!')));
      } else if (code.isEmpty) {
        _promoDiscount = 0.0;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Promo cleared.')));
      } else {
        _promoDiscount = 0.0;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid promo code.')));
      }
    });
  }

  Future<void> _placeOrder(List<CartItem> items) async {
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Your cart is empty.')));
      return;
    }

    if (!_formKey.currentState!.validate()) {
      // Form has errors
      return;
    }

    // Collect shipping address
    final shipping = {
      'name': _nameController.text.trim(),
      'street': _streetController.text.trim(),
      'city': _cityController.text.trim(),
      'postal': _postalController.text.trim(),
      'phone': _phoneController.text.trim(),
    };

    // Summaries
    final subtotal = _computeSubtotal(items);
    final shippingFee = shippingFeeDefault;
    final discount = subtotal * _promoDiscount;
    final taxable = subtotal - discount;
    final tax = taxable * taxRate;
    final total = taxable + tax + shippingFee;

    // Placeholder for payment processing:
    // - If integration exists (Stripe/PayPal/GooglePay), implement here.
    // - For now, simulate a successful order.
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Placing order...'),
        content: Column(mainAxisSize: MainAxisSize.min, children: const [
          CircularProgressIndicator(),
          SizedBox(height: 12),
          Text('Processing your order...'),
        ]),
      ),
    );

    // Simulate delay for processing
    await Future.delayed(const Duration(seconds: 2));

    // Dismiss processing dialog
    if (!mounted) return;
    Navigator.of(context).pop();

    // Clear cart (CartService)
    CartService.instance.clear();

    // Show result
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Order Placed'),
        content: Text(
          'Thanks ${shipping['name']}, your order has been placed.\n'
          'Total: \$${total.toStringAsFixed(2)}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // dismiss dialog
              Navigator.of(context).pop(); // return to previous screen
            },
            child: const Text('Done'),
          )
        ],
      ),
    );
  }

  Widget _buildOrderRow(CartItem item) {
    final subtotal = item.product.price * item.quantity;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.grey[100],
              image: item.product.imageUrl.isNotEmpty
                  ? DecorationImage(image: NetworkImage(item.product.imageUrl), fit: BoxFit.cover)
                  : null,
            ),
            child: item.product.imageUrl.isEmpty ? const Icon(Icons.image, size: 28, color: Colors.grey) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text('x${item.quantity}', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Text('\$${subtotal.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _postalController.dispose();
    _phoneController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use CartService ValueListenableBuilder for UI updates
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder<List<CartItem>>(
          valueListenable: CartService.instance.itemsNotifier,
          builder: (context, items, _) {
            final subtotal = _computeSubtotal(items);
            final discount = subtotal * _promoDiscount;
            final shippingFee = items.isNotEmpty ? shippingFeeDefault : 0.0;
            final taxable = subtotal - discount;
            final tax = taxable * taxRate;
            final total = taxable + tax + shippingFee;

            return Form(
              key: _formKey,
              child: ListView(
                children: [
                  const Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  if (items.isEmpty)
                    Center(child: Text('Your cart is empty', style: Theme.of(context).textTheme.bodyLarge))
                  else
                    Column(children: items.map(_buildOrderRow).toList()),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  const Text('Shipping details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Full name'),
                    validator: (v) => v?.trim().isEmpty ?? true ? 'Please enter your name' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _streetController,
                    decoration: const InputDecoration(labelText: 'Street address'),
                    validator: (v) => v?.trim().isEmpty ?? true ? 'Please enter shipping address' : null,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _cityController,
                          decoration: const InputDecoration(labelText: 'City'),
                          validator: (v) => v?.trim().isEmpty ?? true ? 'Enter a city' : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _postalController,
                          decoration: const InputDecoration(labelText: 'Postal code'),
                          validator: (v) => v?.trim().isEmpty ?? true ? 'Enter postal code' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    keyboardType: TextInputType.phone,
                    validator: (v) => v?.trim().isEmpty ?? true ? 'Enter phone number' : null,
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  const Text('Payment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  RadioListTile<PaymentMethod>(
                    value: PaymentMethod.card,
                    groupValue: _paymentMethod,
                    onChanged: (p) => setState(() => _paymentMethod = p!),
                    title: const Text('Credit/Debit Card'),
                    subtitle: const Text('Pay securely with your card'),
                  ),
                  RadioListTile<PaymentMethod>(
                    value: PaymentMethod.cod,
                    groupValue: _paymentMethod,
                    onChanged: (p) => setState(() => _paymentMethod = p!),
                    title: const Text('Cash on Delivery'),
                  ),

                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),

                  const Text('Promo code', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: _promoController, decoration: const InputDecoration(hintText: 'Enter promo code'))),
                      const SizedBox(width: 8),
                      ElevatedButton(onPressed: _applyPromo, child: const Text('Apply')),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Totals
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('Subtotal'),
                    Text('\$${subtotal.toStringAsFixed(2)}'),
                  ]),
                  const SizedBox(height: 6),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('Discount'),
                    Text('- \$${discount.toStringAsFixed(2)}'),
                  ]),
                  const SizedBox(height: 6),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('Shipping'),
                    Text('\$${shippingFee.toStringAsFixed(2)}'),
                  ]),
                  const SizedBox(height: 6),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('Tax'),
                    Text('\$${tax.toStringAsFixed(2)}'),
                  ]),
                  const Divider(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ]),
                  const SizedBox(height: 16),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    onPressed: () => _placeOrder(items),
                    child: const Text('Place order', style: TextStyle(fontSize: 16)),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
