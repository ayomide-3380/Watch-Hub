import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/support_provider.dart';
import '../../theme/app_theme.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supportProvider = Provider.of<SupportProvider>(context);
    final faqs = supportProvider.filteredFAQs;
    final categories = supportProvider.faqCategories;

    return Scaffold(
      backgroundColor: AppTheme.obsidianBlack,
      appBar: AppBar(
        title: const Text('FREQUENTLY ASKED QUESTIONS'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Selector Pills
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = supportProvider.selectedFAQCategory == category;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    selectedColor: AppTheme.goldAccent,
                    backgroundColor: AppTheme.cardBg,
                    labelStyle: TextStyle(
                      color: isSelected ? AppTheme.obsidianBlack : AppTheme.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                    onSelected: (val) {
                      if (val) supportProvider.setFAQCategory(category);
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Expansion Accordion FAQ List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: faqs.length,
              itemBuilder: (context, index) {
                final faq = faqs[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    iconColor: AppTheme.goldAccent,
                    collapsedIconColor: AppTheme.textMuted,
                    title: Text(
                      faq.question,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      faq.category,
                      style: const TextStyle(color: AppTheme.goldAccent, fontSize: 11),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          faq.answer,
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5),
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
    );
  }
}
