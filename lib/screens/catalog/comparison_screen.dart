import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/watch.dart';
import '../../providers/cart_provider.dart';
import '../../theme/app_theme.dart';

class ComparisonScreen extends StatelessWidget {
  final List<Watch> watches;
  const ComparisonScreen({super.key, required this.watches});

  Widget _buildSpecRow(String title, List<String> values, {bool isHighlighted = false}) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.cardBorder)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row title
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontWeight: FontWeight.bold,
                fontSize: 11,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Values for each watch
          ...values.map(
            (val) => Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  val,
                  style: TextStyle(
                    color: isHighlighted ? AppTheme.goldAccent : AppTheme.textPrimary,
                    fontSize: 12,
                    fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppTheme.obsidianBlack,
      appBar: AppBar(
        title: const Text('COMPARE TIMEPIECES'),
      ),
      body: Column(
        children: [
          // Watch Card Headers
          Container(
            color: AppTheme.darkCharcoal,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'MODEL',
                    style: TextStyle(
                      color: AppTheme.goldAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ...watches.map(
                  (watch) => Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              watch.imageUrls.first,
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            watch.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            currencyFormat.format(watch.price),
                            style: const TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scrollable Specs Table
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildSpecRow(
                    'Brand',
                    watches.map((w) => w.brand).toList(),
                  ),
                  _buildSpecRow(
                    'Category',
                    watches.map((w) => w.category).toList(),
                  ),
                  _buildSpecRow(
                    'Movement',
                    watches.map((w) => w.specifications['Movement'] ?? w.type).toList(),
                  ),
                  _buildSpecRow(
                    'Case Diameter',
                    watches.map((w) => w.specifications['Case Diameter'] ?? 'N/A').toList(),
                  ),
                  _buildSpecRow(
                    'Water Resistance',
                    watches.map((w) => w.specifications['Water Resistance'] ?? 'N/A').toList(),
                    isHighlighted: true,
                  ),
                  _buildSpecRow(
                    'Case Material',
                    watches.map((w) => w.specifications['Case Material'] ?? 'N/A').toList(),
                  ),
                  _buildSpecRow(
                    'Dial Color',
                    watches.map((w) => w.specifications['Dial Color'] ?? 'N/A').toList(),
                  ),
                  _buildSpecRow(
                    'Strap/Bracelet',
                    watches.map((w) => w.specifications['Strap'] ?? 'N/A').toList(),
                  ),
                  _buildSpecRow(
                    'Power Reserve',
                    watches.map((w) => w.specifications['Power Reserve'] ?? 'N/A').toList(),
                  ),
                  _buildSpecRow(
                    'Rating',
                    watches.map((w) => '${w.rating} ★ (${w.reviewCount} reviews)').toList(),
                  ),
                ],
              ),
            ),
          ),

          // Action Buttons: Add to Cart for each
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: const BoxDecoration(
              color: AppTheme.darkCharcoal,
              border: Border(top: BorderSide(color: AppTheme.cardBorder)),
            ),
            child: Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
                const SizedBox(width: 8),
                ...watches.map(
                  (watch) => Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          minimumSize: Size.zero,
                          textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          context.read<CartProvider>().addToCart(watch);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added ${watch.title} to cart!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: const Text('ADD TO CART'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
