import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';
import '../../providers/watch_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/watch.dart';
import '../../models/mock_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/watch_card.dart';
import '../../widgets/app_image.dart';
import '../product_details/product_details_screen.dart';
import '../support/support_chat_screen.dart';
import '../catalog/configurator_screen.dart';
import 'notification_center_screen.dart';
import 'recommendation_quiz_screen.dart';
import '../catalog/brand_showcase_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onNavigateToCatalog;

  const HomeScreen({
    super.key,
    required this.onNavigateToCatalog,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _heroController = PageController();
  final PageController _offersController = PageController();
  
  // Daily Deal Ticker State
  late Timer _dealTimer;
  Duration _dealDuration = const Duration(hours: 14, minutes: 32, seconds: 15);

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _dealTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_dealDuration.inSeconds > 0) {
            _dealDuration = _dealDuration - const Duration(seconds: 1);
          } else {
            // Reset to 24 hours if expires
            _dealDuration = const Duration(hours: 24);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _heroController.dispose();
    _offersController.dispose();
    _dealTimer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final watchProvider = Provider.of<WatchProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final featuredList = watchProvider.featuredWatches;
    final popularList = watchProvider.popularWatches;
    final newArrivals = watchProvider.newArrivals;
    final recentlyViewed = watchProvider.recentlyViewedWatches;

    // Personalized recommendations with custom matching scores
    final recommendedWatches = watchProvider.allWatches
        .where((w) => w.category == 'Diver' || w.category == 'Chronograph')
        .toList();

    // Select Daytona as our Daily Deal watch
    final dailyDealWatch = watchProvider.getWatchById('w_001');

    return Scaffold(
      backgroundColor: AppTheme.obsidianBlack,
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(
          children: [
            const Icon(Icons.watch, color: AppTheme.goldAccent, size: 28),
            const SizedBox(width: 10),
            Text(
              'WATCHHUB',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
            ),
          ],
        ),
        actions: [
          // Notification Bell
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: AppTheme.goldAccent),
                tooltip: 'Notifications',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationCenterScreen()),
                  );
                },
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.headset_mic_outlined, color: AppTheme.goldAccent),
            tooltip: 'Customer Support Chat',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SupportChatScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, ${user?.name ?? "Collector"}',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Discover Masterpieces',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.goldAccent.withOpacity(0.4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.verified_user_outlined, color: AppTheme.goldAccent, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${user?.vipStatus.toUpperCase() ?? "SILVER"} TIER',
                          style: const TextStyle(
                            color: AppTheme.goldAccent,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Hero Carousel Section
            if (featuredList.isNotEmpty)
              Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: _heroController,
                      itemCount: featuredList.length,
                      itemBuilder: (context, index) {
                        final watch = featuredList[index];
                        return _buildHeroCard(context, watch);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SmoothPageIndicator(
                    controller: _heroController,
                    count: featuredList.length,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: AppTheme.goldAccent,
                      dotColor: AppTheme.cardBorder,
                      dotHeight: 6,
                      dotWidth: 6,
                      expansionFactor: 3,
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 24),

            // Daily Deal Countdown Banner
            if (dailyDealWatch != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.goldAccent.withOpacity(0.6), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.goldAccent.withOpacity(0.1),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.redAccent),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.flash_on, color: Colors.redAccent, size: 10),
                                      SizedBox(width: 4),
                                      Text(
                                        'BOUTIQUE FLASH DEAL',
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    const Icon(Icons.timer_outlined, color: AppTheme.goldAccent, size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      _formatDuration(_dealDuration),
                                      style: const TextStyle(
                                        color: AppTheme.goldAccent,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              dailyDealWatch.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Special pricing ends soon. Includes complimentary insured shipping.',
                              style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text(
                                  '\$${(dailyDealWatch.price * 0.9).toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    color: AppTheme.goldAccent,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '\$${dailyDealWatch.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    color: AppTheme.textMuted,
                                    fontSize: 14,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.successGreen,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'SAVE 10%',
                                    style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              dailyDealWatch.imageUrls.first,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              minimumSize: Size.zero,
                              textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailsScreen(watchId: dailyDealWatch.id),
                                ),
                              );
                            },
                            child: const Text('CLAIM DEAL'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Style Quiz Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2C3039), Color(0xFF1D2026)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.roseGold.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.psychology_outlined, color: AppTheme.roseGold, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Timepiece Matchmaker Quiz',
                                style: TextStyle(
                                  color: AppTheme.roseGold,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Answer 4 brief questions to discover your ideal watch style compatibility profile.',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 11,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.roseGold,
                              foregroundColor: AppTheme.obsidianBlack,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              minimumSize: Size.zero,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RecommendationQuizScreen(),
                                ),
                              );
                            },
                            child: const Text('START STYLE QUIZ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.auto_awesome, color: AppTheme.roseGold, size: 48),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Brand Selector Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'TOP MANUFACTURES',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: MockData.brands.length,
                itemBuilder: (context, index) {
                  final brand = MockData.brands[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ActionChip(
                      backgroundColor: AppTheme.cardBg,
                      side: const BorderSide(color: AppTheme.cardBorder),
                      label: Text(
                        brand,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BrandShowcaseScreen(brandName: brand),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Custom Configurator Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E1E1E), Color(0xFF2C2C2C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.goldAccent.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.design_services_outlined, color: AppTheme.goldAccent, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Bespoke Atelier',
                                style: TextStyle(
                                  color: AppTheme.goldAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Design your dream timepiece. Customize case metals, bezels, dials, and straps in real-time.',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.goldAccent,
                              foregroundColor: AppTheme.obsidianBlack,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ConfiguratorScreen(),
                                ),
                              );
                            },
                            child: const Text('BUILD YOUR WATCH', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Popular Timepieces Horizontal Header & List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CURATED SELECTION',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  GestureDetector(
                    onTap: widget.onNavigateToCatalog,
                    child: const Text(
                      'View Catalog >',
                      style: TextStyle(
                        color: AppTheme.goldAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 270,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: popularList.length,
                itemBuilder: (context, index) {
                  final watch = popularList[index];
                  return Container(
                    width: 185,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    child: WatchCard(
                      watch: watch,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(watchId: watch.id),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 28),

            // Recently Viewed watches section (if any exist)
            if (recentlyViewed.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'RECENTLY VIEWED TIMEPIECES',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 270,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: recentlyViewed.length,
                  itemBuilder: (context, index) {
                    final watch = recentlyViewed[index];
                    return Container(
                      width: 185,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      child: WatchCard(
                        watch: watch,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(watchId: watch.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 28),
            ],

            // Mock Personalized Offers / Coupons Carousel
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'YOUR VIP PRIVILEGES',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  color: AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: PageView(
                  controller: _offersController,
                  children: [
                    _buildCouponCard(
                      title: 'Complimentary Strap Upgrade',
                      code: 'STRAPVIP26',
                      desc: 'Get an extra Alligator strap with any Rolex purchase.',
                      icon: Icons.auto_awesome,
                    ),
                    _buildCouponCard(
                      title: '\$500 Off Platinum Models',
                      code: 'PLATINUM500',
                      desc: 'Save on bespoke platinum configurations.',
                      icon: Icons.diamond_outlined,
                    ),
                    _buildCouponCard(
                      title: 'Free Armored Transit Insurance',
                      code: 'SAFECOURIER',
                      desc: 'Zero shipping fees on order values exceeding \$10k.',
                      icon: Icons.shield_outlined,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Concierge Banner Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.cardBg, AppTheme.darkCharcoal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.goldAccent.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'WatchHub Private Concierge',
                            style: TextStyle(
                              color: AppTheme.goldAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Need sourcing for a rare timepiece or custom strap fitting?',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SupportChatScreen(),
                                ),
                              );
                            },
                            child: const Text('TALK TO CONCIERGE', style: TextStyle(fontSize: 11)),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.auto_awesome, color: AppTheme.goldAccent, size: 40),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Personalized Recommendation Dashboard
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome, color: AppTheme.goldAccent, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'TAILORED FOR YOU',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Based on your interest in Luxury Divers & Chronographs',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 280,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recommendedWatches.length,
                      itemBuilder: (context, index) {
                        final watch = recommendedWatches[index];
                        // Assign simulated compatibility scores: 98%, 95%, 91%...
                        final compatibilityScore = 98 - (index * 4);
                        return Container(
                          width: 185,
                          margin: const EdgeInsets.only(right: 12),
                          child: Stack(
                            children: [
                              WatchCard(
                                watch: watch,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailsScreen(watchId: watch.id),
                                    ),
                                  );
                                },
                              ),
                              Positioned(
                                top: 10,
                                left: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.obsidianBlack.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: AppTheme.goldAccent.withOpacity(0.6)),
                                  ),
                                  child: Text(
                                    '$compatibilityScore% MATCH',
                                    style: const TextStyle(
                                      color: AppTheme.goldAccent,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // New Arrivals Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'NEW ARRIVALS',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final crossAxisCount = screenWidth > 1200
                    ? 5
                    : (screenWidth > 900 ? 4 : (screenWidth > 600 ? 3 : 2));
                
                // Calculate childAspectRatio dynamically so cards are exactly 280 logical pixels high
                const double padding = 32.0; // 16.0 * 2 padding
                final double spacing = (crossAxisCount - 1) * 14.0;
                final double cardWidth = (screenWidth - padding - spacing) / crossAxisCount;
                const double targetHeight = 280.0;
                final double childAspectRatio = cardWidth / targetHeight;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: childAspectRatio,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: newArrivals.length,
                  itemBuilder: (context, index) {
                    final watch = newArrivals[index];
                    return WatchCard(
                      watch: watch,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(watchId: watch.id),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponCard({
    required String title,
    required String code,
    required String desc,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.goldAccent, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.goldAccent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppTheme.goldAccent.withOpacity(0.4)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('CODE', style: TextStyle(color: AppTheme.textMuted, fontSize: 7, fontWeight: FontWeight.bold)),
                Text(
                  code,
                  style: const TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 0.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context, Watch watch) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AppImage(
              url: watch.imageUrls.first,
              fit: BoxFit.cover,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppTheme.obsidianBlack.withValues(alpha: 0.92),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.goldAccent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'FEATURED MASTERPIECE',
                      style: TextStyle(
                        color: AppTheme.obsidianBlack,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    watch.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        watch.brand.toUpperCase(),
                        style: const TextStyle(
                          color: AppTheme.goldAccent,
                          fontSize: 12,
                          letterSpacing: 1.0,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(watchId: watch.id),
                            ),
                          );
                        },
                        child: const Text('EXPLORE >', style: TextStyle(color: AppTheme.goldAccent)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
