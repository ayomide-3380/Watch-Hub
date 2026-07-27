import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class WatchCareGuideScreen extends StatelessWidget {
  const WatchCareGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.obsidianBlack,
      appBar: AppBar(
        title: const Text('WATCH CARE GUIDE'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(Icons.settings_suggest_outlined, color: AppTheme.goldAccent, size: 48),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'MAINTAINING EXTRAORDINARY PRECISION',
                style: TextStyle(
                  color: AppTheme.goldAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Center(
              child: Text(
                'Essential guidelines to preserve your investment timepiece.',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),

            _buildCareCard(
              icon: Icons.history_toggle_off,
              title: 'Manual & Automatic Winding',
              desc: 'For automatic movements, wear daily or keep inside an electric watch winder. For manual-wind calibres, wind at the same time each day until you feel slight resistance. Never force the crown.',
            ),
            _buildCareCard(
              icon: Icons.water_drop_outlined,
              title: 'Water Resistance Checks',
              desc: 'Before exposing your watch to water, ensure the crown is fully screwed down. Have water-resistance gaskets tested annually, especially if you dive or swim with a luxury model.',
            ),
            _buildCareCard(
              icon: Icons.thunderstorm_outlined,
              title: 'Avoiding Magnetic Fields',
              desc: 'Keep mechanical timepieces away from magnetic fields found in speakers, laptops, refrigerators, and magnetic clasps. Magnetism causes hairspring coils to bind, making the watch run fast.',
            ),
            _buildCareCard(
              icon: Icons.clean_hands_outlined,
              title: 'Regular Cleaning & Detailing',
              desc: 'Wipe with a microfibre lint-free cloth daily. For metal bracelets, wash periodically using warm soapy water and a soft-bristled brush. Ensure the crown is fully tightened before cleaning.',
            ),
            _buildCareCard(
              icon: Icons.history,
              title: 'Servicing Intervallic Schedules',
              desc: 'Schedule a complete lubrication service every 3 to 5 years. Master horologists disassemble, clean, lubricate, and adjust the movement, renewing its lifetime chronometer accuracy.',
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildCareCard({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.goldAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppTheme.goldAccent, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4),
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
