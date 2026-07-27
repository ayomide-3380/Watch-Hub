import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/order_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/order_status_stepper.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final orderProvider = Provider.of<OrderProvider>(context);
    final order = orderProvider.getOrderById(orderId);

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('TRACK ORDER')),
        body: const Center(child: Text('Order reference not found.')),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.obsidianBlack,
      appBar: AppBar(
        title: Text('TRACK #${order.id}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mock Radar Transit Map
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.cardBorder),
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&q=80&w=600'),
                  fit: BoxFit.cover,
                  opacity: 0.25,
                ),
              ),
              child: Stack(
                children: [
                  // Pulse animation indicator
                  Positioned(
                    top: 60,
                    left: 120,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppTheme.goldAccent.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppTheme.goldAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      color: Colors.black87,
                      child: const Row(
                        children: [
                          Icon(Icons.radar, color: AppTheme.goldAccent, size: 12),
                          SizedBox(width: 4),
                          Text('ARMOURED CAR TRANSIT ACTIVE', style: TextStyle(color: AppTheme.goldAccent, fontSize: 8, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Order Status Overview Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.goldAccent.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order.statusDisplay.toUpperCase(),
                        style: const TextStyle(
                          color: AppTheme.goldAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.darkCharcoal,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.goldAccent),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.local_shipping_outlined, color: AppTheme.goldAccent, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'Armored Express',
                              style: TextStyle(color: AppTheme.goldAccent, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Purchased: ${DateFormat('MMMM dd, yyyy').format(order.orderDate)}',
                    style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                  ),
                  Text(
                    'Total Amount: ${currencyFormat.format(order.totalAmount)} (${order.items.length} Timepiece)',
                    style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),
            Text('REAL-TIME TRACKING TIMELINE', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 16),

            // Stepper Timeline
            OrderStatusStepper(steps: order.trackingSteps),

            const SizedBox(height: 24),
            const Divider(color: AppTheme.cardBorder),
            const SizedBox(height: 16),

            // Delivery Details Card
            Text('DESTINATION ADDRESS', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: AppTheme.goldAccent, size: 28),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Armored Direct Courier', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 4),
                          Text(order.shippingAddress, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
