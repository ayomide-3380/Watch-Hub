import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/watch_provider.dart';
import '../../models/watch.dart';
import '../../theme/app_theme.dart';
import '../../widgets/watch_card.dart';
import '../product_details/product_details_screen.dart';

class BrandShowcaseScreen extends StatelessWidget {
  final String brandName;

  const BrandShowcaseScreen({super.key, required this.brandName});

  // Mock brand stories and milestones
  Map<String, dynamic> _getBrandHeritage() {
    switch (brandName.toLowerCase()) {
      case 'rolex':
        return {
          'tagline': 'A Crown for Every Achievement',
          'description': 'Founded in 1905 by Hans Wilsdorf, Rolex pioneered the dustproof Oyster casing in 1926. Renowned for durability, high-impact adventure, and ultimate luxury prestige.',
          'image': 'https://images.unsplash.com/photo-1547996160-01ff60023533?auto=format&fit=crop&q=80&w=800',
          'milestones': [
            {'year': '1926', 'title': 'First Waterproof Watch', 'desc': 'Rolex creates the Oyster, the world\'s first waterproof wrist watch.'},
            {'year': '1945', 'title': 'The Datejust', 'desc': 'The first self-winding chronometer to show the date in a dial window.'},
            {'year': '1953', 'title': 'Submariner Launch', 'desc': 'Pioneering diving watch waterproof to 100 meters.'},
            {'year': '1963', 'title': 'Daytona Racing Chronograph', 'desc': 'Designed specifically for professional race drivers.'},
          ]
        };
      case 'omega':
        return {
          'tagline': 'First Watch on the Moon',
          'description': 'Beginning in 1848, Omega has accompanied explorers to the moon, deep oceanic trenches, and athletic championships, certifying time with precision Master Chronometer standards.',
          'image': 'https://images.unsplash.com/photo-1542496658-e33a6d0d50f6?auto=format&fit=crop&q=80&w=800',
          'milestones': [
            {'year': '1932', 'title': 'Olympic Games Timing', 'desc': 'Omega becomes the official timekeeper of the Los Angeles Olympic Games.'},
            {'year': '1957', 'title': 'Speedmaster Professional', 'desc': 'Launches the watch that would eventually go to the moon.'},
            {'year': '1969', 'title': 'Lunar Landing', 'desc': 'Buzz Aldrin wears the Speedmaster on the lunar surface.'},
            {'year': '1993', 'title': 'Seamaster Diver 300M', 'desc': 'The modern classic diver worn by James Bond.'},
          ]
        };
      case 'patek philippe':
        return {
          'tagline': 'You Never Actually Own a Patek Philippe',
          'description': 'Epitomizing Swiss horology since 1839. Generational hand-finished mechanical calibres, complex complications, and timeless aesthetic designs.',
          'image': 'https://images.unsplash.com/photo-1614164185128-e4ec99c436d7?auto=format&fit=crop&q=80&w=800',
          'milestones': [
            {'year': '1868', 'title': 'First Swiss Wristwatch', 'desc': 'Patek Philippe creates a wristwatch for Countess Koscowicz of Hungary.'},
            {'year': '1932', 'title': 'The Calatrava', 'desc': 'The signature dress watch silhouette is introduced.'},
            {'year': '1976', 'title': 'The Nautilus Launch', 'desc': 'Gérald Genta designs the iconic luxury sports watch.'},
            {'year': '2001', 'title': 'Sky Moon Tourbillon', 'desc': 'One of the most complex double-faced wristwatches ever built.'},
          ]
        };
      default:
        return {
          'tagline': 'Excellence in Horology',
          'description': 'Crafting luxury precision instruments with hand-assembled calibres, sapphire structural dials, and premium materials.',
          'image': 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&q=80&w=800',
          'milestones': [
            {'year': '1900', 'title': 'Atelier Foundation', 'desc': 'Pioneering early mechanical designs.'},
            {'year': '1950', 'title': 'Chronometer Standard', 'desc': 'Achieving certified timing precision.'},
          ]
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final watchProvider = Provider.of<WatchProvider>(context);
    final brandData = _getBrandHeritage();
    final List<Watch> brandWatches = watchProvider.allWatches
        .where((w) => w.brand.toLowerCase() == brandName.toLowerCase())
        .toList();

    return Scaffold(
      backgroundColor: AppTheme.obsidianBlack,
      body: CustomScrollView(
        slivers: [
          // Glassmorphic Parallax Header
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppTheme.obsidianBlack,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                brandName.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(brandData['image'], fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.obsidianBlack, AppTheme.obsidianBlack.withOpacity(0.3), Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Story & Heritage Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    brandData['tagline'].toUpperCase(),
                    style: const TextStyle(
                      color: AppTheme.goldAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'HERITAGE & CRAFTSMANSHIP',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    brandData['description'],
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5),
                  ),
                  const SizedBox(height: 28),

                  // Timeline section
                  const Text(
                    'HISTORICAL TIMELINE',
                    style: TextStyle(
                      color: AppTheme.goldAccent,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTimeline(brandData['milestones']),

                  const SizedBox(height: 32),
                  // Watches Grid
                  Text(
                    'AVAILABLE MODELS (${brandWatches.length})',
                    style: const TextStyle(
                      color: AppTheme.goldAccent,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Brand Models Grid
          if (brandWatches.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text('No models currently listed for this brand.', style: TextStyle(color: AppTheme.textMuted)),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.70,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final watch = brandWatches[index];
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
                  childCount: brandWatches.length,
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildTimeline(List<dynamic> milestones) {
    return Column(
      children: List.generate(milestones.length, (idx) {
        final step = milestones[idx];
        final isLast = idx == milestones.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.goldAccent.withOpacity(0.12),
                    border: Border.all(color: AppTheme.goldAccent.withOpacity(0.6)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    step['year'],
                    style: const TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 1,
                    height: 50,
                    color: AppTheme.cardBorder,
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      step['desc'],
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11, height: 1.3),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
