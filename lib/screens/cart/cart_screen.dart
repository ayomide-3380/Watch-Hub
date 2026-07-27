import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/cart_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
import 'checkout_dialog.dart';

class CartScreen extends StatefulWidget {
  final VoidCallback onNavigateToCatalog;

  const CartScreen({super.key, required this.onNavigateToCatalog});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Scaffold(
      backgroundColor: AppTheme.obsidianBlack,
      appBar: AppBar(
        title: const Text('SHOPPING CART'),
        actions: [
          if (cartProvider.items.isNotEmpty)
            TextButton(
              onPressed: () => cartProvider.clearCart(),
              child: const Text('Clear All', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
            ),
        ],
      ),
      body: cartProvider.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_bag_outlined, color: AppTheme.textMuted, size: 72),
                  const SizedBox(height: 16),
                  Text(
                    'Your Cart is Empty',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Explore our exclusive vault of luxury timepieces.',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: widget.onNavigateToCatalog,
                    child: const Text('EXPLORE CATALOG'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartProvider.items.length,
                    itemBuilder: (context, index) {
                      final item = cartProvider.items[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              // Watch Image Thumbnail
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: AppImage(
                                  url: item.watch.imageUrls.first,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Info Column
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.watch.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: AppTheme.textPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Color: ${item.selectedColor} | Strap: ${item.selectedStrap}',
                                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      currencyFormat.format(item.watch.price),
                                      style: const TextStyle(
                                        color: AppTheme.goldAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Quantity Controls & Remove
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: AppTheme.textMuted, size: 18),
                                    onPressed: () => cartProvider.removeItem(item),
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () => cartProvider.updateQuantity(item, item.quantity - 1),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: AppTheme.darkCharcoal,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Icon(Icons.remove, size: 14, color: AppTheme.textPrimary),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          '${item.quantity}',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => cartProvider.updateQuantity(item, item.quantity + 1),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: AppTheme.darkCharcoal,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Icon(Icons.add, size: 14, color: AppTheme.textPrimary),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Promo Code & Summary Bottom Panel
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppTheme.darkCharcoal,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    border: Border(top: BorderSide(color: AppTheme.cardBorder)),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Promo Code Row
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _promoController,
                                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                                decoration: const InputDecoration(
                                  hintText: 'Enter Promo Code (e.g. WATCHHUB10)',
                                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              onPressed: () {
                                final success = cartProvider.applyPromoCode(_promoController.text);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      success
                                          ? 'Promo code applied successfully!'
                                          : 'Invalid promo code',
                                    ),
                                  ),
                                );
                              },
                              child: const Text('APPLY'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Subtotal, Tax, Shipping breakdown
                        _buildPriceRow('Subtotal', currencyFormat.format(cartProvider.subtotal)),
                        if (cartProvider.discountAmount > 0)
                          _buildPriceRow(
                            'Promo Discount (${cartProvider.appliedPromoCode})',
                            '-${currencyFormat.format(cartProvider.discountAmount)}',
                            isDiscount: true,
                          ),
                        _buildPriceRow('Estimated Tax (8%)', currencyFormat.format(cartProvider.tax)),
                        _buildPriceRow(
                          'Armored Express Shipping',
                          cartProvider.shippingFee == 0
                              ? 'COMPLIMENTARY'
                              : currencyFormat.format(cartProvider.shippingFee),
                        ),
                        const Divider(color: AppTheme.cardBorder, height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Grand Total',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              currencyFormat.format(cartProvider.grandTotal),
                              style: const TextStyle(
                                color: AppTheme.goldAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () => CheckoutModal.show(context),
                            child: const Text('PROCEED TO CHECKOUT'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPriceRow(String title, String val, {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          Text(
            val,
            style: TextStyle(
              color: isDiscount ? AppTheme.successGreen : AppTheme.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
