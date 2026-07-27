import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/watch.dart';
import '../providers/wishlist_provider.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import 'app_image.dart';

class WatchCard extends StatefulWidget {
  final Watch watch;
  final VoidCallback onTap;
  final bool isSelected; // Support gold border glow

  const WatchCard({
    super.key,
    required this.watch,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  State<WatchCard> createState() => _WatchCardState();
}

class _WatchCardState extends State<WatchCard> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _heartController;
  late Animation<double> _heartScale;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heartScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _heartController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  void _playHeartPop() {
    _heartController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final isWishlisted = wishlistProvider.isWishlisted(widget.watch.id);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isSelected
                  ? AppTheme.goldAccent
                  : (widget.watch.isFeatured ? AppTheme.goldAccent.withOpacity(0.3) : AppTheme.cardBorder),
              width: widget.isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.isSelected
                    ? AppTheme.goldAccent.withOpacity(0.2)
                    : Colors.black.withOpacity(0.3),
                blurRadius: widget.isSelected ? 15 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Proportional Image & Badge Stack (60% Height)
              Expanded(
                flex: 6,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Hero(
                        tag: 'watch_img_${widget.watch.id}',
                        child: AppImage(
                          url: widget.watch.imageUrls.first,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Brand Pill
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.obsidianBlack.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.goldAccent.withOpacity(0.5)),
                        ),
                        child: Text(
                          widget.watch.brand.toUpperCase(),
                          style: const TextStyle(
                            color: AppTheme.goldAccent,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),

                    // Wishlist Heart Button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        radius: 17,
                        backgroundColor: AppTheme.obsidianBlack.withOpacity(0.75),
                        child: ScaleTransition(
                          scale: _heartScale,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 18,
                            icon: Icon(
                              isWishlisted ? Icons.favorite : Icons.favorite_border,
                              color: isWishlisted ? Colors.redAccent : AppTheme.textPrimary,
                            ),
                            onPressed: () {
                              _playHeartPop();
                              wishlistProvider.toggleWishlist(widget.watch);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isWishlisted
                                        ? 'Removed from Wishlist'
                                        : 'Added to Wishlist!',
                                  ),
                                  duration: const Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    // Low Stock Badge
                    if (widget.watch.stockCount <= 3 && widget.watch.isAvailable)
                      Positioned(
                        bottom: 8,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.errorRed,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'ONLY ${widget.watch.stockCount} LEFT',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Proportional Watch Details (40% Height)
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.watch.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.star, color: AppTheme.goldAccent, size: 13),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.watch.rating}',
                                style: const TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                ' (${widget.watch.reviewCount})',
                                style: const TextStyle(
                                  color: AppTheme.textMuted,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currencyFormat.format(widget.watch.price),
                                  style: const TextStyle(
                                    color: AppTheme.goldAccent,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (widget.watch.hasDiscount)
                                  Text(
                                    currencyFormat.format(widget.watch.originalPrice),
                                    style: const TextStyle(
                                      color: AppTheme.textMuted,
                                      fontSize: 10,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          // Add to Cart Quick Icon Button
                          InkWell(
                            onTap: () {
                              cartProvider.addToCart(widget.watch);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Added ${widget.watch.title} to Cart'),
                                  duration: const Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: AppTheme.goldAccent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.shopping_bag_outlined,
                                color: AppTheme.obsidianBlack,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
