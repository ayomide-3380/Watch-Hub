import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/watch_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/watch.dart';
import '../../theme/app_theme.dart';
import '../product_details/product_details_screen.dart';

class RecommendationQuizScreen extends StatefulWidget {
  const RecommendationQuizScreen({super.key});

  @override
  State<RecommendationQuizScreen> createState() => _RecommendationQuizScreenState();
}

class _RecommendationQuizScreenState extends State<RecommendationQuizScreen> {
  int _currentStep = 0;
  
  // Selection State
  String? _selectedStyle;
  String? _selectedBudget;
  String? _selectedSize;
  String? _selectedMovement;

  final List<String> _styles = ['Luxury', 'Chronograph', 'Diver', 'Dress', 'Smart'];
  final List<String> _budgets = ['Under \$5,000', '\$5,000 - \$15,000', '\$15,000 - \$30,000', '\$30,000+'];
  final List<String> _sizes = ['Under 40 mm', '40 mm - 42 mm', '42 mm+'];
  final List<String> _movements = ['Automatic', 'Manual Wind', 'Quartz', 'Bespoke / Smart'];

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final isActive = _currentStep == index;
        final isDone = _currentStep > index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isActive ? 24 : 8,
          decoration: BoxDecoration(
            color: isDone || isActive ? AppTheme.goldAccent : AppTheme.cardBorder,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.goldAccent.withOpacity(0.1) : AppTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppTheme.goldAccent : AppTheme.cardBorder,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.goldAccent.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: isSelected ? AppTheme.goldAccent : AppTheme.textSecondary),
              const SizedBox(width: 14),
            ],
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? AppTheme.goldAccent : AppTheme.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppTheme.goldAccent, size: 20)
            else
              const Icon(Icons.circle_outlined, color: AppTheme.textMuted, size: 20),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _calculateRecommendations() {
    final watchProvider = Provider.of<WatchProvider>(context, listen: false);
    final allWatches = watchProvider.allWatches;

    List<Map<String, dynamic>> results = [];

    for (var watch in allWatches) {
      double matchScore = 0.0;

      // 1. Style / Category match (35%)
      if (_selectedStyle != null && watch.category.toLowerCase() == _selectedStyle!.toLowerCase()) {
        matchScore += 35.0;
      }

      // 2. Budget match (30%)
      if (_selectedBudget != null) {
        final price = watch.price;
        if (_selectedBudget == 'Under \$5,000' && price < 5000) {
          matchScore += 30.0;
        } else if (_selectedBudget == '\$5,000 - \$15,000' && price >= 5000 && price <= 15000) {
          matchScore += 30.0;
        } else if (_selectedBudget == '\$15,000 - \$30,000' && price > 15000 && price <= 30000) {
          matchScore += 30.0;
        } else if (_selectedBudget == '\$30,000+' && price > 30000) {
          matchScore += 30.0;
        } else {
          // Partial points for being close
          matchScore += 10.0;
        }
      }

      // 3. Movement Type match (20%)
      if (_selectedMovement != null) {
        final mType = watch.type.toLowerCase();
        final selectedM = _selectedMovement!.toLowerCase();
        if (selectedM == 'automatic' && mType.contains('automatic')) {
          matchScore += 20.0;
        } else if (selectedM == 'manual wind' && mType.contains('manual')) {
          matchScore += 20.0;
        } else if (selectedM == 'quartz' && mType.contains('quartz')) {
          matchScore += 20.0;
        } else if (selectedM == 'bespoke / smart' && (mType.contains('smart') || mType.contains('solar') || mType.contains('bespoke'))) {
          matchScore += 20.0;
        } else {
          matchScore += 5.0; // fallback partial match
        }
      }

      // 4. Case size match (15%)
      if (_selectedSize != null) {
        final sizeStr = watch.specifications['Case Diameter'] ?? '';
        final diameter = double.tryParse(sizeStr.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 40.0;
        if (_selectedSize == 'Under 40 mm' && diameter < 40) {
          matchScore += 15.0;
        } else if (_selectedSize == '40 mm - 42 mm' && diameter >= 40 && diameter <= 42) {
          matchScore += 15.0;
        } else if (_selectedSize == '42 mm+' && diameter > 42) {
          matchScore += 15.0;
        } else {
          matchScore += 5.0;
        }
      }

      results.add({
        'watch': watch,
        'score': matchScore.clamp(0.0, 100.0).round(),
      });
    }

    // Sort by match score descending
    results.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
    
    // Unlock style explorer badge
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().unlockBadge('Style Explorer');
    });

    return results.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.obsidianBlack,
      appBar: AppBar(
        title: const Text('STYLE SELECTOR QUIZ'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildStepIndicator(),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildQuizBody(),
              ),
            ),
            if (_currentStep < 4) ...[
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentStep > 0)
                      OutlinedButton(
                        onPressed: () => setState(() => _currentStep--),
                        child: const Text('PREVIOUS'),
                      )
                    else
                      const SizedBox(),
                    ElevatedButton(
                      onPressed: _isCurrentStepValid()
                          ? () => setState(() => _currentStep++)
                          : null,
                      child: const Text('CONTINUE'),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _isCurrentStepValid() {
    if (_currentStep == 0) return _selectedStyle != null;
    if (_currentStep == 1) return _selectedBudget != null;
    if (_currentStep == 2) return _selectedSize != null;
    if (_currentStep == 3) return _selectedMovement != null;
    return true;
  }

  Widget _buildQuizBody() {
    switch (_currentStep) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Which style represents your personality best?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select a category that aligns with your lifestyle.',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            ..._styles.map((style) => _buildOptionCard(
                  title: style,
                  icon: _getStyleIcon(style),
                  isSelected: _selectedStyle == style,
                  onTap: () => setState(() => _selectedStyle = style),
                )),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What budget fits your search?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            const Text(
              'Luxury watches are investment timepieces.',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            ..._budgets.map((budget) => _buildOptionCard(
                  title: budget,
                  icon: Icons.payments_outlined,
                  isSelected: _selectedBudget == budget,
                  onTap: () => setState(() => _selectedBudget = budget),
                )),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What diameter case size do you prefer?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            const Text(
              'Depends on your wrist size (e.g. 40mm is classic average).',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            ..._sizes.map((size) => _buildOptionCard(
                  title: size,
                  icon: Icons.straighten,
                  isSelected: _selectedSize == size,
                  onTap: () => setState(() => _selectedSize = size),
                )),
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Which watch movement drives your passion?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            const Text(
              'Mechanical systems have gears, quartz runs on battery.',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            ..._movements.map((movement) => _buildOptionCard(
                  title: movement,
                  icon: Icons.history_toggle_off,
                  isSelected: _selectedMovement == movement,
                  onTap: () => setState(() => _selectedMovement = movement),
                )),
          ],
        );
      default:
        final recommendations = _calculateRecommendations();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(Icons.auto_awesome, color: AppTheme.goldAccent, size: 48),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'YOUR STYLE PROFILE COMPILED',
                style: TextStyle(
                  color: AppTheme.goldAccent,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Center(
              child: Text(
                'We have matched these models with your choices',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
              ),
            ),
            const SizedBox(height: 24),
            ...recommendations.map((rec) {
              final Watch watch = rec['watch'];
              final int score = rec['score'];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              watch.imageUrls.first,
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  watch.brand.toUpperCase(),
                                  style: const TextStyle(
                                    color: AppTheme.goldAccent,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  watch.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  watch.type,
                                  style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: AppTheme.cardBorder, height: 1),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.favorite, color: AppTheme.goldAccent, size: 14),
                              const SizedBox(width: 6),
                              Text(
                                '$score% Compatibility Match',
                                style: const TextStyle(
                                  color: AppTheme.goldAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              minimumSize: Size.zero,
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailsScreen(watchId: watch.id),
                                ),
                              );
                            },
                            child: const Text('EXPLORE', style: TextStyle(fontSize: 10)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('FINISH & RETURN'),
              ),
            ),
            const SizedBox(height: 30),
          ],
        );
    }
  }

  IconData _getStyleIcon(String style) {
    switch (style) {
      case 'Luxury':
        return Icons.diamond_outlined;
      case 'Chronograph':
        return Icons.timer_outlined;
      case 'Diver':
        return Icons.sailing;
      case 'Dress':
        return Icons.business_center_outlined;
      case 'Smart':
        return Icons.watch_outlined;
      default:
        return Icons.watch;
    }
  }
}
