import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../orders/order_history_screen.dart';
import '../support/support_chat_screen.dart';
import '../support/faq_screen.dart';
import '../support/report_issue_screen.dart';
import '../admin/admin_dashboard_screen.dart';
import 'saved_payments_screen.dart';
import 'saved_addresses_screen.dart';
import 'watch_care_guide_screen.dart';
import 'vip_status_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showEditProfileModal(BuildContext context, AuthProvider auth) {
    final nameCtrl = TextEditingController(text: auth.user?.name);
    final phoneCtrl = TextEditingController(text: auth.user?.phone);
    final addrCtrl = TextEditingController(text: auth.user?.defaultAddress);

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
            Text('Edit Personal Details', style: Theme.of(ctx).textTheme.headlineSmall),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: addrCtrl,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(labelText: 'Primary Shipping Address'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  auth.updateProfile(
                    name: nameCtrl.text.trim(),
                    phone: phoneCtrl.text.trim(),
                    defaultAddress: addrCtrl.text.trim(),
                  );
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile details updated!')),
                  );
                },
                child: const Text('SAVE CHANGES'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
    final points = user?.loyaltyPoints ?? 350;
    final vipTier = user?.vipStatus ?? 'Gold';
    final badges = user?.unlockedBadges ?? ['Horology Enthusiast'];

    return Scaffold(
      backgroundColor: AppTheme.obsidianBlack,
      appBar: AppBar(
        title: const Text('MY ACCOUNT'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppTheme.goldAccent),
            onPressed: () => _showEditProfileModal(context, auth),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // User Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundImage: NetworkImage(
                      user?.avatarUrl ??
                          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=400',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Guest Collector',
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.email ?? '',
                          style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const VIPStatusScreen()),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.goldAccent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.goldAccent.withOpacity(0.5)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star, color: AppTheme.goldAccent, size: 12),
                                const SizedBox(width: 4),
                                Text(
                                  '$vipTier Privileges'.toUpperCase(),
                                  style: const TextStyle(
                                    color: AppTheme.goldAccent,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.chevron_right, color: AppTheme.goldAccent, size: 12),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // VIP Progress Bar summary
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VIPStatusScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('LOYALTY POINTS BALANCE', style: TextStyle(color: AppTheme.textMuted, fontSize: 9, fontWeight: FontWeight.bold)),
                        Text('$points pts', style: const TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (points / 1500).clamp(0.0, 1.0),
                        minHeight: 6,
                        backgroundColor: AppTheme.obsidianBlack,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.goldAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Mode Switcher Banner (Admin Panel Toggle)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.darkCharcoal,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.goldAccent.withOpacity(0.4)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.admin_panel_settings_outlined, color: AppTheme.goldAccent),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Admin Portal View', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text('Access store inventory & order management', style: TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                  Switch(
                    value: auth.isAdminMode,
                    activeColor: AppTheme.goldAccent,
                    onChanged: (val) {
                      auth.toggleAdminMode();
                      if (val) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Purchase History Analytics (Expenditure Charts)
            _buildSectionHeader('EXPENDITURE ANALYTICS'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Spending by Watch Category', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildAnalyticsBar('Luxury', '\$34,500', 0.9, AppTheme.goldAccent),
                  _buildAnalyticsBar('Chronograph', '\$6,850', 0.25, AppTheme.roseGold),
                  _buildAnalyticsBar('Diver', '\$0', 0.0, AppTheme.textMuted),
                  _buildAnalyticsBar('Dress', '\$0', 0.0, AppTheme.textMuted),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Achievement Gallery Grid
            _buildSectionHeader('ATELIER ACHIEVEMENTS'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 2.2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildBadgeCard('Horology Enthusiast', Icons.watch, badges.contains('Horology Enthusiast')),
                  _buildBadgeCard('Bespoke Creator', Icons.design_services, badges.contains('Bespoke Creator')),
                  _buildBadgeCard('Style Explorer', Icons.psychology, badges.contains('Style Explorer')),
                  _buildBadgeCard('High Roller', Icons.diamond, badges.contains('High Roller')),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Account Actions List
            _buildSectionHeader('ORDERS & SETTINGS'),
            _buildListTile(
              context,
              icon: Icons.local_shipping_outlined,
              title: 'Order History & Armored Tracking',
              subtitle: 'Track active deliveries and view invoice receipts',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
                );
              },
            ),
            _buildListTile(
              context,
              icon: Icons.credit_card_outlined,
              title: 'Wallet & Payment Cards',
              subtitle: 'Manage saved debit and premium credit cards',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SavedPaymentsScreen()),
                );
              },
            ),
            _buildListTile(
              context,
              icon: Icons.home_outlined,
              title: 'Address Book',
              subtitle: 'Manage secure delivery addresses',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SavedAddressesScreen()),
                );
              },
            ),

            const SizedBox(height: 20),
            _buildSectionHeader('CONCIERGE & CARE'),
            _buildListTile(
              context,
              icon: Icons.clean_hands_outlined,
              title: 'Watch Care Guide',
              subtitle: 'Horology guidelines to maintain mechanical movements',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WatchCareGuideScreen()),
                );
              },
            ),
            _buildListTile(
              context,
              icon: Icons.headset_mic_outlined,
              title: 'In-App Live Chat',
              subtitle: 'Connect with a certified horology specialist',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SupportChatScreen()),
                );
              },
            ),
            _buildListTile(
              context,
              icon: Icons.help_outline,
              title: 'Frequently Asked Questions',
              subtitle: 'Warranty, authenticity certificates, & shipping FAQs',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FAQScreen()),
                );
              },
            ),
            _buildListTile(
              context,
              icon: Icons.report_problem_outlined,
              title: 'Report an Issue / Feedback',
              subtitle: 'Submit service requests or report issues directly',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReportIssueScreen()),
                );
              },
            ),

            const SizedBox(height: 28),

            // Sign out button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('SIGN OUT'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.errorRed,
                  side: const BorderSide(color: AppTheme.errorRed),
                ),
                onPressed: () => auth.logout(),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 4),
        child: Text(
          title,
          style: const TextStyle(
            color: AppTheme.goldAccent,
            fontWeight: FontWeight.bold,
            fontSize: 11,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyticsBar(String label, String value, double percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11))),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: 12,
                backgroundColor: AppTheme.obsidianBlack,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBadgeCard(String title, IconData icon, bool isUnlocked) {
    return Container(
      decoration: BoxDecoration(
        color: isUnlocked ? AppTheme.goldAccent.withOpacity(0.08) : Colors.black38,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnlocked ? AppTheme.goldAccent.withOpacity(0.5) : AppTheme.cardBorder,
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Icon(
            icon,
            color: isUnlocked ? AppTheme.goldAccent : AppTheme.textMuted,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isUnlocked ? Colors.white : AppTheme.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  isUnlocked ? 'UNLOCKED' : 'LOCKED',
                  style: TextStyle(
                    color: isUnlocked ? AppTheme.goldAccent : AppTheme.textMuted,
                    fontSize: 7,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.darkCharcoal,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.goldAccent, size: 20),
        ),
        title: Text(title, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textMuted),
      ),
    );
  }
}
