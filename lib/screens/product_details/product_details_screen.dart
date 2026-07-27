import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../providers/watch_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/review_provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/zoomable_image.dart';
import '../../widgets/app_image.dart';
import '../../widgets/interactive_360_viewer.dart';
import 'ar_tryon_screen.dart';
import '../../models/watch.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String watchId;

  const ProductDetailsScreen({super.key, required this.watchId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final PageController _imagePageController = PageController();
  late String _selectedColor;
  late String _selectedStrap;
  int _selectedQuantity = 1;
  bool _is360Mode = false;

  // Active Specifications tab: 0 = Gauges, 1 = Story, 2 = Timeline
  int _activeSpecsTab = 0;

  @override
  void initState() {
    super.initState();
    final watch = Provider.of<WatchProvider>(context, listen: false).getWatchById(widget.watchId);
    if (watch != null) {
      _selectedColor = watch.availableColors.first;
      _selectedStrap = watch.availableStraps.first;
    }
    
    // Add to recently viewed list
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WatchProvider>().addToRecentlyViewed(widget.watchId);
    });
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }

  void _showAddReviewModal(BuildContext context) {
    double rating = 5.0;
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.darkCharcoal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Write a Review', style: Theme.of(ctx).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Center(
              child: RatingBar.builder(
                initialRating: 5,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: AppTheme.goldAccent,
                ),
                onRatingUpdate: (val) => rating = val,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: commentController,
              maxLines: 4,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Share your experience with this timepiece...',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (commentController.text.trim().isNotEmpty) {
                    final user = ctx.read<AuthProvider>().user;
                    ctx.read<ReviewProvider>().addReview(
                          watchId: widget.watchId,
                          userName: user?.name ?? 'Watch Enthusiast',
                          userAvatar: user?.avatarUrl ?? '',
                          rating: rating,
                          comment: commentController.text.trim(),
                        );
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Review submitted for verification!')),
                    );
                  }
                },
                child: const Text('SUBMIT REVIEW'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Size Guide Bottom Sheet
  void _showSizeGuideBottomSheet(BuildContext context) {
    double selectedWristSize = 17.0; // cm

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkCharcoal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bctx) => StatefulBuilder(
        builder: (sctx, setModalState) {
          String recommendedDiameter = '40mm - 42mm';
          if (selectedWristSize < 16.0) {
            recommendedDiameter = '36mm - 38mm';
          } else if (selectedWristSize > 18.5) {
            recommendedDiameter = '44mm - 46mm';
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('WATCH SIZE GUIDE', style: TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.0)),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppTheme.textMuted),
                      onPressed: () => Navigator.pop(bctx),
                    ),
                  ],
                ),
                const Divider(color: AppTheme.cardBorder),
                const SizedBox(height: 12),
                const Text(
                  'Measure your wrist circumference below to find the recommended luxury timepiece diameter casing.',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Wrist Circumference:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text(
                      '${selectedWristSize.toStringAsFixed(1)} cm / ${(selectedWristSize / 2.54).toStringAsFixed(1)} in',
                      style: const TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
                Slider(
                  value: selectedWristSize,
                  min: 14.0,
                  max: 22.0,
                  divisions: 16,
                  activeColor: AppTheme.goldAccent,
                  inactiveColor: AppTheme.cardBorder,
                  onChanged: (val) {
                    setModalState(() {
                      selectedWristSize = val;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.cardBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified, color: AppTheme.goldAccent, size: 28),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('RECOMMENDED DIAMETER', style: TextStyle(color: AppTheme.textMuted, fontSize: 8, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text(
                              recommendedDiameter,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    final watchProvider = Provider.of<WatchProvider>(context);
    final watch = watchProvider.getWatchById(widget.watchId);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final reviewProvider = Provider.of<ReviewProvider>(context);

    if (watch == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Watch not found')),
      );
    }

    final isWishlisted = wishlistProvider.isWishlisted(watch.id);
    final reviews = reviewProvider.getReviewsForWatch(watch.id);

    return Scaffold(
      backgroundColor: AppTheme.obsidianBlack,
      body: CustomScrollView(
        slivers: [
          // App Bar with Image Slider & Hero
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            backgroundColor: AppTheme.obsidianBlack,
            actions: [
              IconButton(
                icon: Icon(
                  isWishlisted ? Icons.favorite : Icons.favorite_border,
                  color: isWishlisted ? Colors.redAccent : AppTheme.goldAccent,
                ),
                onPressed: () => wishlistProvider.toggleWishlist(watch),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (_is360Mode)
                    Interactive360Viewer(imageUrls: watch.imageUrls)
                  else
                    PageView.builder(
                      controller: _imagePageController,
                      itemCount: watch.imageUrls.length,
                      itemBuilder: (context, index) {
                        final imgUrl = watch.imageUrls[index];
                        return GestureDetector(
                          onTap: () => ZoomableImageModal.show(context, imgUrl, watch.title),
                          child: Hero(
                            tag: index == 0 ? 'watch_img_${watch.id}' : 'watch_img_${watch.id}_$index',
                            child: AppImage(
                              url: imgUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        );
                      },
                    ),

                  // 360 Toggle Button
                  Positioned(
                    top: 90,
                    left: 16,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _is360Mode = !_is360Mode;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _is360Mode ? AppTheme.goldAccent : AppTheme.obsidianBlack.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.goldAccent.withOpacity(0.5)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _is360Mode ? Icons.threed_rotation : Icons.rotate_right,
                              color: _is360Mode ? AppTheme.obsidianBlack : AppTheme.goldAccent,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _is360Mode ? 'STANDARD VIEW' : '360° VIEW',
                              style: TextStyle(
                                color: _is360Mode ? AppTheme.obsidianBlack : AppTheme.goldAccent,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // AR Try On Button
                  Positioned(
                    top: 90,
                    left: 146,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ARTryOnScreen(watch: watch),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.roseGold,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.roseGold.withOpacity(0.5)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.camera_alt_outlined, color: AppTheme.obsidianBlack, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'AR TRY-ON',
                              style: TextStyle(
                                color: AppTheme.obsidianBlack,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Pinch Zoom Hint Badge
                  if (!_is360Mode)
                    Positioned(
                      top: 90,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.obsidianBlack.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.goldAccent.withOpacity(0.5)),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            final currentIdx = _imagePageController.hasClients
                                ? _imagePageController.page?.round() ?? 0
                                : 0;
                            ZoomableImageModal.show(
                              context,
                              watch.imageUrls[currentIdx],
                              watch.title,
                            );
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.zoom_in, color: AppTheme.goldAccent, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'ZOOM IN',
                                style: TextStyle(
                                  color: AppTheme.goldAccent,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // Smooth Page Indicator
                  if (!_is360Mode)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: SmoothPageIndicator(
                          controller: _imagePageController,
                          count: watch.imageUrls.length,
                          effect: const WormEffect(
                            activeDotColor: AppTheme.goldAccent,
                            dotColor: AppTheme.cardBorder,
                            dotHeight: 8,
                            dotWidth: 8,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Details Content List
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand & Stock Casing Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        watch.brand.toUpperCase(),
                        style: const TextStyle(
                          color: AppTheme.goldAccent,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 13,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: watch.isAvailable ? AppTheme.cardBg : AppTheme.errorRed,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppTheme.cardBorder),
                        ),
                        child: Text(
                          watch.isAvailable
                              ? 'IN STOCK (${watch.stockCount} LEFT)'
                              : 'OUT OF STOCK',
                          style: TextStyle(
                            color: watch.isAvailable ? AppTheme.successGreen : Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Watch Title
                  Text(
                    watch.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),

                  // Rating & Review summary
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppTheme.goldAccent, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        '${watch.rating}',
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${watch.reviewCount} customer reviews)',
                        style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Pricing Section
                  Row(
                    children: [
                      Text(
                        currencyFormat.format(watch.price),
                        style: const TextStyle(
                          color: AppTheme.goldAccent,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (watch.hasDiscount) ...[
                        const SizedBox(width: 12),
                        Text(
                          currencyFormat.format(watch.originalPrice),
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 16,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.roseGold,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '-${watch.discountPercentage}% OFF',
                            style: const TextStyle(
                              color: AppTheme.obsidianBlack,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),

                  const Divider(color: AppTheme.cardBorder),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    'DESCRIPTION',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    watch.description,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Color Selector & Strap Selector with Size Guide Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('DIAL COLOR & STRAP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      TextButton.icon(
                        icon: const Icon(Icons.straighten, size: 14, color: AppTheme.roseGold),
                        label: const Text('Size Guide', style: TextStyle(color: AppTheme.roseGold, fontSize: 12, fontWeight: FontWeight.bold)),
                        onPressed: () => _showSizeGuideBottomSheet(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: watch.availableColors.map((color) {
                      final isSelected = _selectedColor == color;
                      return ChoiceChip(
                        label: Text(color),
                        selected: isSelected,
                        selectedColor: AppTheme.goldAccent,
                        backgroundColor: AppTheme.cardBg,
                        labelStyle: TextStyle(
                          color: isSelected ? AppTheme.obsidianBlack : AppTheme.textPrimary,
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _selectedColor = color);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: watch.availableStraps.map((strap) {
                      final isSelected = _selectedStrap == strap;
                      return ChoiceChip(
                        label: Text(strap),
                        selected: isSelected,
                        selectedColor: AppTheme.roseGold,
                        backgroundColor: AppTheme.cardBg,
                        labelStyle: TextStyle(
                          color: isSelected ? AppTheme.obsidianBlack : AppTheme.textPrimary,
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _selectedStrap = strap);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  const Divider(color: AppTheme.cardBorder),
                  const SizedBox(height: 16),

                  // Visual Specifications Section (Pills Selector for Tabs)
                  Row(
                    children: [
                      _buildSpecTabPill(0, 'SPEC GAUGE'),
                      const SizedBox(width: 8),
                      _buildSpecTabPill(1, 'OUR STORY'),
                      const SizedBox(width: 8),
                      _buildSpecTabPill(2, 'TIMELINE'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Tab Content Rendering
                  _buildActiveSpecsContent(watch),

                  const SizedBox(height: 24),
                  const Divider(color: AppTheme.cardBorder),
                  const SizedBox(height: 16),

                  // Digital Authenticity Certificate
                  _buildBlockchainCertificate(watch),

                  const SizedBox(height: 32),

                  // Reviews Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'REVIEWS & RATINGS',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.rate_review_outlined, size: 16, color: AppTheme.goldAccent),
                        label: const Text('Write Review', style: TextStyle(color: AppTheme.goldAccent)),
                        onPressed: () => _showAddReviewModal(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (reviews.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          'No reviews yet for this model. Be the first to leave a review!',
                          style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        final rev = reviews[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(rev.userAvatar),
                                      radius: 18,
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          rev.userName,
                                          style: const TextStyle(
                                            color: AppTheme.textPrimary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.verified, color: AppTheme.goldAccent, size: 12),
                                            const SizedBox(width: 4),
                                            Text(
                                              rev.isVerifiedPurchase ? 'Verified Owner' : 'Reviewer',
                                              style: const TextStyle(color: AppTheme.goldAccent, fontSize: 11),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: List.generate(
                                        5,
                                        (i) => Icon(
                                          i < rev.rating ? Icons.star : Icons.star_border,
                                          color: AppTheme.goldAccent,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  rev.comment,
                                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                                ),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton.icon(
                                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                    icon: const Icon(Icons.thumb_up_alt_outlined, size: 14, color: AppTheme.textMuted),
                                    label: Text('Helpful (${rev.helpfulCount})',
                                        style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                                    onPressed: () => reviewProvider.markHelpful(rev.id),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Add to Cart & Buy Now Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.darkCharcoal,
          border: const Border(top: BorderSide(color: AppTheme.cardBorder)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Quantity selector
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 16, color: AppTheme.textPrimary),
                      onPressed: () {
                        if (_selectedQuantity > 1) {
                          setState(() => _selectedQuantity--);
                        }
                      },
                    ),
                    Text(
                      '$_selectedQuantity',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 16, color: AppTheme.textPrimary),
                      onPressed: () {
                        if (_selectedQuantity < watch.stockCount) {
                          setState(() => _selectedQuantity++);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),

              // Add to Cart Button
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: watch.isAvailable
                        ? () {
                            cartProvider.addToCart(
                              watch,
                              color: _selectedColor,
                              strap: _selectedStrap,
                              quantity: _selectedQuantity,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Added $_selectedQuantity x ${watch.title} to Cart'),
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        : null,
                    child: Text(watch.isAvailable ? 'ADD TO CART' : 'SOLD OUT'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecTabPill(int index, String title) {
    final isActive = _activeSpecsTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeSpecsTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? AppTheme.goldAccent : AppTheme.cardBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isActive ? AppTheme.goldAccent : AppTheme.cardBorder,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isActive ? AppTheme.obsidianBlack : AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 10,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveSpecsContent(Watch watch) {
    if (_activeSpecsTab == 0) {
      // 1. Visual spec gauges (progress bars)
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSpecGaugeBar('Power Reserve', '72 Hours', 0.9, AppTheme.goldAccent),
            _buildSpecGaugeBar('Water Resistance', watch.specifications['Water Resistance'] ?? '100 meters', 0.6, Colors.blueAccent),
            _buildSpecGaugeBar('Accuracy Rating', 'Swiss Chronometer Standard (+/-2s/day)', 0.95, AppTheme.successGreen),
            _buildSpecGaugeBar('Atelier Craftsmanship Finishing', '100% Hand-finished Casing', 1.0, AppTheme.roseGold),
          ],
        ),
      );
    } else if (_activeSpecsTab == 1) {
      // 2. Story Accordion
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'THE HOROLOGICAL LEGACY',
              style: TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.8),
            ),
            const SizedBox(height: 6),
            const Text(
              'Every timepiece reflects decades of research in metallurgic durability. The components are individually hand-polished in our private Swiss atelier, matching traditional hand-carved chamfers with mirror-like black polished details.',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4),
            ),
            const SizedBox(height: 14),
            const Text(
              'THE PRECISION MOVEMENT',
              style: TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.8),
            ),
            const SizedBox(height: 6),
            Text(
              'Running on calibre mechanical movement: ${watch.specifications['Movement'] ?? "Automatic swiss mechanical"}. Incorporating structural balance springs to prevent magnetic field timing loss.',
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4),
            ),
          ],
        ),
      );
    } else {
      // 3. Historical Timeline
      final List<Map<String, String>> sampleTimeline = [
        {'year': '1963', 'title': 'First Reference Introduced', 'desc': 'Unveiled for professional tracking.'},
        {'year': '1988', 'title': 'Self-winding Movement Upgrade', 'desc': 'Adopted a modified chronograph layout.'},
        {'year': '2000', 'title': 'In-house Calibre Caliber', 'desc': 'Integrated modern vertical clutch mechanics.'},
        {'year': '2026', 'title': 'Bespoke Ceramic Atelier', 'desc': 'Released in Chestnut chestnut trim.'},
      ];

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.cardBorder),
        ),
        child: Column(
          children: List.generate(sampleTimeline.length, (idx) {
            final step = sampleTimeline[idx];
            final isLast = idx == sampleTimeline.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 6,
                      backgroundColor: AppTheme.goldAccent,
                    ),
                    if (!isLast)
                      Container(
                        width: 1,
                        height: 38,
                        color: AppTheme.cardBorder,
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${step['year']} — ${step['title']}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          step['desc']!,
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      );
    }
  }

  Widget _buildSpecGaugeBar(String label, String value, double pct, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              Text(value, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 6,
              backgroundColor: AppTheme.obsidianBlack,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockchainCertificate(Watch watch) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.goldAccent.withOpacity(0.4)),
        gradient: LinearGradient(
          colors: [AppTheme.cardBg, AppTheme.obsidianBlack.withOpacity(0.4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.shield, color: AppTheme.goldAccent, size: 20),
              SizedBox(width: 8),
              Text(
                'DIGITAL CERTIFICATE OF AUTHENTICITY',
                style: TextStyle(
                  color: AppTheme.goldAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'This timepiece is catalogued and certified authentic. A secure blockchain verification registry record verifies ownership.',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, height: 1.3),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('REGISTRY HASH', style: TextStyle(color: AppTheme.textMuted, fontSize: 8, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(
                    'SHA-256 #${watch.id.hashCode.abs().toString().padRight(12, '9')}',
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'monospace', fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.successGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppTheme.successGreen),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check, color: AppTheme.successGreen, size: 10),
                    SizedBox(width: 4),
                    Text('COSC CERTIFIED', style: TextStyle(color: AppTheme.successGreen, fontSize: 8, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
