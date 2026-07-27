import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/order_provider.dart';
import '../../theme/app_theme.dart';
import 'order_tracking_screen.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;

    return Scaffold(
      backgroundColor: AppTheme.obsidianBlack,
      appBar: AppBar(
        title: const Text('ORDER HISTORY'),
      ),
      body: orders.isEmpty
          ? const Center(
              child: Text(
                'No orders placed yet.',
                style: TextStyle(color: AppTheme.textMuted),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ORDER #${order.id}',
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppTheme.goldAccent.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppTheme.goldAccent),
                              ),
                              child: Text(
                                order.statusDisplay,
                                style: const TextStyle(
                                  color: AppTheme.goldAccent,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Date: ${DateFormat('MMM dd, yyyy').format(order.orderDate)}',
                          style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                        ),
                        const Divider(color: AppTheme.cardBorder, height: 20),

                        // Item preview list
                        ...order.items.map((item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.network(item.watch.imageUrls.first, width: 40, height: 40, fit: BoxFit.cover),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item.watch.title, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.bold)),
                                        Text('Qty: ${item.quantity} | ${item.selectedColor}', style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                                      ],
                                    ),
                                  ),
                                  Text(currencyFormat.format(item.totalPrice), style: const TextStyle(color: AppTheme.goldAccent, fontSize: 13)),
                                ],
                              ),
                            )),

                        const Divider(color: AppTheme.cardBorder, height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total: ${currencyFormat.format(order.totalAmount)}',
                              style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderTrackingScreen(orderId: order.id),
                                  ),
                                );
                              },
                              child: const Text('TRACK SHIPMENT', style: TextStyle(fontSize: 11)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
