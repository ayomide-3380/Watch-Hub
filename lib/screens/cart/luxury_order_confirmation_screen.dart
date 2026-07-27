import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/order.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../orders/order_tracking_screen.dart';

class LuxuryOrderConfirmationScreen extends StatefulWidget {
  final Order order;

  const LuxuryOrderConfirmationScreen({super.key, required this.order});

  @override
  State<LuxuryOrderConfirmationScreen> createState() => _LuxuryOrderConfirmationScreenState();
}

class _LuxuryOrderConfirmationScreenState extends State<LuxuryOrderConfirmationScreen> with SingleTickerProviderStateMixin {
  bool _isUnboxed = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.2), weight: 40),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 1.0), weight: 60),
    ]).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _rotationAnimation = Tween<double>(begin: 0, end: 6.28).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    // Award loyalty points for checkout (e.g. 5% of order value)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pointsAwarded = (widget.order.totalAmount / 100).round();
      context.read<AuthProvider>().addPoints(pointsAwarded);
      context.read<AuthProvider>().unlockBadge('High Roller');
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _triggerUnboxing() {
    _animationController.forward().then((_) {
      setState(() {
        _isUnboxed = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final pointsAwarded = (widget.order.totalAmount / 100).round();

    return Scaffold(
      backgroundColor: AppTheme.obsidianBlack,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // Luxury Title Header
              Center(
                child: Text(
                  'ATELIER WATCHHUB',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppTheme.goldAccent,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Bespoke Hand-Finished Timepieces',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontStyle: FontStyle.italic),
                ),
              ),
              
              const SizedBox(height: 40),

              // Animated Box Casing / Unboxing View
              Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  child: !_isUnboxed
                      ? Column(
                          key: const ValueKey('closed_box'),
                          children: [
                            const Text(
                              'YOUR TIMEPIECE CHEST HAS ARRIVED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Closed Watch Box
                            ScaleTransition(
                              scale: _scaleAnimation,
                              child: RotationTransition(
                                turns: _rotationAnimation,
                                child: Container(
                                  width: 160,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    color: AppTheme.cardBg,
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(color: AppTheme.goldAccent, width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.goldAccent.withOpacity(0.3),
                                        blurRadius: 30,
                                        spreadRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.inventory_2_outlined, color: AppTheme.goldAccent, size: 64),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                              ),
                              icon: const Icon(Icons.key, color: AppTheme.obsidianBlack),
                              label: const Text('TAP TO UNBOX TIMEPIECE'),
                              onPressed: _triggerUnboxing,
                            ),
                          ],
                        )
                      : Column(
                          key: const ValueKey('opened_box'),
                          children: [
                            const Icon(Icons.stars, color: AppTheme.goldAccent, size: 44),
                            const SizedBox(height: 12),
                            const Text(
                              'UNBOXING COMPLETE',
                              style: TextStyle(
                                color: AppTheme.goldAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Your watch has cleared final calibration testing.',
                              style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                            ),
                            const SizedBox(height: 20),
                            // Opened glowing watch display
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                color: AppTheme.cardBg,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppTheme.goldAccent.withOpacity(0.8), width: 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.goldAccent.withOpacity(0.25),
                                    blurRadius: 25,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(12),
                              child: ClipOval(
                                child: Image.network(
                                  widget.order.items.first.watch.imageUrls.first,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 40),

              // Order Confirmation details
              if (_isUnboxed) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.cardBorder),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow('Reference ID', widget.order.id, isGold: true),
                      const SizedBox(height: 8),
                      _buildDetailRow('Total Paid', currencyFormat.format(widget.order.totalAmount)),
                      const SizedBox(height: 8),
                      _buildDetailRow('VIP Loyalty points earned', '+$pointsAwarded pts', isGreen: true),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderTrackingScreen(orderId: widget.order.id),
                        ),
                      );
                    },
                    child: const Text('TRACK SECURE DISPATCH'),
                  ),
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isGold = false, bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        Text(
          value,
          style: TextStyle(
            color: isGold
                ? AppTheme.goldAccent
                : (isGreen ? AppTheme.successGreen : Colors.white),
            fontWeight: FontWeight.bold,
            fontSize: 12,
            fontFamily: isGold ? 'monospace' : null,
          ),
        ),
      ],
    );
  }
}
