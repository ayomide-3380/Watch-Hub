import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';

class VIPStatusScreen extends StatelessWidget {
  const VIPStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
    final points = user?.loyaltyPoints ?? 350;
    final vipTier = user?.vipStatus ?? 'Gold';

    double progress = 0.0;
    int pointsNeeded = 0;
    String nextTier = '';
    
    if (vipTier == 'Silver') {
      progress = points / 500;
      pointsNeeded = 500 - points;
      nextTier = 'Gold';
    } else if (vipTier == 'Gold') {
      progress = (points - 500) / 500;
      pointsNeeded = 1000 - points;
      nextTier = 'Platinum';
    } else {
      progress = 1.0;
      pointsNeeded = 0;
      nextTier = 'Supreme Collector';
    }

    return Scaffold(
      backgroundColor: AppTheme.obsidianBlack,
      appBar: AppBar(
        title: const Text('VIP PRIVILEGE'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Gold Glowing Tier Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E1E1E), Color(0xFF14161B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.goldAccent, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.goldAccent.withOpacity(0.18),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.stars, color: AppTheme.goldAccent, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    '$vipTier Member'.toUpperCase(),
                    style: const TextStyle(
                      color: AppTheme.goldAccent,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$points Total Horology Points',
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 24),

                  // Progress tracker
                  if (pointsNeeded > 0) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tier Progress', style: TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                        Text('$pointsNeeded points to $nextTier', style: const TextStyle(color: AppTheme.goldAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        minHeight: 8,
                        backgroundColor: AppTheme.obsidianBlack,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.goldAccent),
                      ),
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.successGreen.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'MAXIMUM VIP LEVEL REACHED',
                        style: TextStyle(color: AppTheme.successGreen, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Benefits Section
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'YOUR BOUTIQUE PRIVILEGES',
                style: TextStyle(
                  color: AppTheme.goldAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildPrivilegeRow(
              icon: Icons.local_shipping_outlined,
              title: 'Armored Transit Courier',
              desc: 'Priority overnight dispatch with full valuation liability insurance on every purchase.',
            ),
            _buildPrivilegeRow(
              icon: Icons.support_agent_outlined,
              title: '24/7 Private Horologist Concierge',
              desc: 'Connected to a designated boutique manager for customized fittings, allocations, and repairs.',
            ),
            _buildPrivilegeRow(
              icon: Icons.event_note_outlined,
              title: 'Exclusive Collector Access',
              desc: 'Early access invitation for reservation requests on limited edition models and releases.',
            ),
            _buildPrivilegeRow(
              icon: Icons.card_membership_outlined,
              title: 'Point Redemption Rewards',
              desc: 'Earn points on every purchase (5% value equivalent) to spend on custom straps and upgrades.',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivilegeRow({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.goldAccent, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textPrimary)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
