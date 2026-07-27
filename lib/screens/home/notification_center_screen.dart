import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  State<NotificationCenterScreen> createState() => _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 'n1',
      'title': 'VIP Allocations Released',
      'body': 'A limited quantity of the Cosmograph Daytona Platinum is now reserved for premium collectors.',
      'type': 'Exclusive',
      'time': '10 mins ago',
      'isRead': false,
    },
    {
      'id': 'n2',
      'title': 'Bespoke Atelier Open',
      'body': 'Design your dream watch case using custom fluted bezels and Italian Saffiano straps.',
      'type': 'Promotion',
      'time': '2 hours ago',
      'isRead': false,
    },
    {
      'id': 'n3',
      'title': 'Speedmaster Back in Stock',
      'body': 'The Omega Speedmaster Professional Moonwatch is now available for immediate dispatch.',
      'type': 'Inventory',
      'time': '1 day ago',
      'isRead': true,
    },
    {
      'id': 'n4',
      'title': 'Secure Delivery Dispatch',
      'body': 'Your armored courier tracking code has been issued. Signature is required upon delivery.',
      'type': 'Shipping',
      'time': '3 days ago',
      'isRead': true,
    },
  ];

  void _markAllRead() {
    setState(() {
      for (var item in _notifications) {
        item['isRead'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Color _getBadgeColor(String type) {
    switch (type) {
      case 'Exclusive':
        return AppTheme.goldAccent;
      case 'Inventory':
        return AppTheme.successGreen;
      case 'Shipping':
        return AppTheme.infoBlue;
      default:
        return AppTheme.roseGold;
    }
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'Exclusive':
        return Icons.diamond_outlined;
      case 'Inventory':
        return Icons.hourglass_empty;
      case 'Shipping':
        return Icons.local_shipping_outlined;
      default:
        return Icons.local_offer_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.obsidianBlack,
      appBar: AppBar(
        title: const Text('NOTIFICATION CENTER'),
        actions: [
          if (_notifications.any((n) => !n['isRead']))
            IconButton(
              icon: const Icon(Icons.mark_chat_read_outlined, color: AppTheme.goldAccent),
              tooltip: 'Mark all as read',
              onPressed: _markAllRead,
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, color: AppTheme.textMuted, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    'No Notifications Yet',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'We will alert you on order status & boutique releases.',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final item = _notifications[index];
                final isUnread = !item['isRead'];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: isUnread ? AppTheme.cardBg : AppTheme.cardBg.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isUnread ? AppTheme.goldAccent.withOpacity(0.4) : AppTheme.cardBorder,
                      width: isUnread ? 1.2 : 1,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      setState(() {
                        item['isRead'] = true;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Notification Type Icon
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: _getBadgeColor(item['type']).withOpacity(0.12),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _getBadgeColor(item['type']).withOpacity(0.3),
                              ),
                            ),
                            child: Icon(
                              _getIcon(item['type']),
                              color: _getBadgeColor(item['type']),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Content Text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: _getBadgeColor(item['type']).withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        item['type'].toUpperCase(),
                                        style: TextStyle(
                                          color: _getBadgeColor(item['type']),
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      item['time'],
                                      style: const TextStyle(
                                        color: AppTheme.textMuted,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item['title'],
                                  style: TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['body'],
                                  style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 12,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
