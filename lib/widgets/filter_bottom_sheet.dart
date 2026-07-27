import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/watch_provider.dart';
import '../models/mock_data.dart';
import '../theme/app_theme.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.darkCharcoal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const FilterBottomSheet(),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String _tempCategory;
  late String _tempBrand;
  late RangeValues _tempPriceRange;
  late SortOption _tempSortBy;
  late String _tempMovement;
  late double _tempDiameter;

  @override
  void initState() {
    super.initState();
    final watchProvider = Provider.of<WatchProvider>(context, listen: false);
    _tempCategory = watchProvider.selectedCategory;
    _tempBrand = watchProvider.selectedBrand;
    _tempPriceRange = watchProvider.priceRange;
    _tempSortBy = watchProvider.sortBy;
    _tempMovement = watchProvider.selectedMovement;
    _tempDiameter = watchProvider.selectedDiameter;
  }

  @override
  Widget build(BuildContext context) {
    final watchProvider = Provider.of<WatchProvider>(context);
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar & Title Header
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.cardBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter & Sort Watches',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                TextButton(
                  onPressed: () {
                    watchProvider.resetFilters();
                    Navigator.pop(context);
                  },
                  child: const Text('Reset All', style: TextStyle(color: AppTheme.goldAccent)),
                ),
              ],
            ),
            const Divider(color: AppTheme.cardBorder),
            const SizedBox(height: 12),

            // Categories Selection
            const Text('Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: MockData.categories.map((category) {
                final isSelected = _tempCategory == category;
                return ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  selectedColor: AppTheme.goldAccent,
                  backgroundColor: AppTheme.cardBg,
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.obsidianBlack : AppTheme.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => _tempCategory = category);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Brand Selection
            const Text('Brand', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['All', ...MockData.brands].map((brand) {
                final isSelected = _tempBrand == brand;
                return ChoiceChip(
                  label: Text(brand),
                  selected: isSelected,
                  selectedColor: AppTheme.roseGold,
                  backgroundColor: AppTheme.cardBg,
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.obsidianBlack : AppTheme.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => _tempBrand = brand);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Movement Type Advanced Filter
            const Text('Casing Calibre Movement', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['All', 'Automatic', 'Manual', 'Quartz'].map((m) {
                final isSelected = _tempMovement == m;
                return ChoiceChip(
                  label: Text(m),
                  selected: isSelected,
                  selectedColor: AppTheme.goldAccent,
                  backgroundColor: AppTheme.cardBg,
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.obsidianBlack : AppTheme.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => _tempMovement = m);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Case Diameter Slider Advanced Filter
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Max Casing Diameter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(
                  '${_tempDiameter.toStringAsFixed(0)} mm',
                  style: const TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Slider(
              value: _tempDiameter,
              min: 36.0,
              max: 46.0,
              divisions: 10,
              activeColor: AppTheme.goldAccent,
              inactiveColor: AppTheme.cardBorder,
              onChanged: (val) => setState(() => _tempDiameter = val),
            ),
            const SizedBox(height: 20),

            // Price Range Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Price Range', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(
                  '${currencyFormat.format(_tempPriceRange.start)} - ${currencyFormat.format(_tempPriceRange.end)}',
                  style: const TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            RangeSlider(
              values: _tempPriceRange,
              min: 0,
              max: 60000,
              divisions: 60,
              activeColor: AppTheme.goldAccent,
              inactiveColor: AppTheme.cardBorder,
              labels: RangeLabels(
                currencyFormat.format(_tempPriceRange.start),
                currencyFormat.format(_tempPriceRange.end),
              ),
              onChanged: (values) => setState(() => _tempPriceRange = values),
            ),
            const SizedBox(height: 20),

            // Sort Options
            const Text('Sort By', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            Column(
              children: [
                _buildSortRadio(SortOption.featured, 'Featured & Recommendations'),
                _buildSortRadio(SortOption.priceLowToHigh, 'Price: Low to High'),
                _buildSortRadio(SortOption.priceHighToLow, 'Price: High to Low'),
                _buildSortRadio(SortOption.popularity, 'Most Popular / Best Sellers'),
                _buildSortRadio(SortOption.rating, 'Highest Rated'),
              ],
            ),
            const SizedBox(height: 20),

            // Apply Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  watchProvider.setCategory(_tempCategory);
                  watchProvider.setBrand(_tempBrand);
                  watchProvider.setPriceRange(_tempPriceRange);
                  watchProvider.setSortOption(_tempSortBy);
                  watchProvider.setMovement(_tempMovement);
                  watchProvider.setDiameter(_tempDiameter);
                  Navigator.pop(context);
                },
                child: const Text('APPLY FILTERS'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortRadio(SortOption option, String title) {
    return RadioListTile<SortOption>(
      value: option,
      groupValue: _tempSortBy,
      activeColor: AppTheme.goldAccent,
      dense: true,
      title: Text(title, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14)),
      onChanged: (val) {
        if (val != null) setState(() => _tempSortBy = val);
      },
    );
  }
}
