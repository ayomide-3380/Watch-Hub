import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/watch_provider.dart';
import '../../models/mock_data.dart';
import '../../models/watch.dart';
import '../../theme/app_theme.dart';
import '../../widgets/watch_card.dart';
import '../../widgets/filter_bottom_sheet.dart';
import '../product_details/product_details_screen.dart';
import 'comparison_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isCompareMode = false;
  final List<Watch> _selectedCompareList = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final watchProvider = Provider.of<WatchProvider>(context);
    final filteredList = watchProvider.filteredWatches;

    return Scaffold(
      backgroundColor: AppTheme.obsidianBlack,
      appBar: AppBar(
        title: const Text('WATCH CATALOG'),
        actions: [
          IconButton(
            icon: Icon(
              _isCompareMode ? Icons.close_outlined : Icons.compare_arrows_outlined,
              color: _isCompareMode ? AppTheme.errorRed : AppTheme.goldAccent,
            ),
            tooltip: _isCompareMode ? 'Cancel Compare' : 'Compare Timepieces',
            onPressed: () {
              setState(() {
                _isCompareMode = !_isCompareMode;
                _selectedCompareList.clear();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppTheme.goldAccent),
            onPressed: () => FilterBottomSheet.show(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search & Filter Bar Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Search by model, brand, or specs...',
                          prefixIcon: const Icon(Icons.search, color: AppTheme.goldAccent),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, color: AppTheme.textMuted),
                                  onPressed: () {
                                    _searchController.clear();
                                    watchProvider.setSearchQuery('');
                                  },
                                )
                              : null,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onChanged: (val) => watchProvider.setSearchQuery(val),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => FilterBottomSheet.show(context),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.goldAccent.withOpacity(0.6)),
                        ),
                        child: const Icon(Icons.tune, color: AppTheme.goldAccent, size: 22),
                      ),
                    ),
                  ],
                ),
              ),

              // Categories Tabs Carousel
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: MockData.categories.length,
                  itemBuilder: (context, index) {
                    final category = MockData.categories[index];
                    final isSelected = watchProvider.selectedCategory == category;

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
                        onSelected: (selected) {
                          if (selected) watchProvider.setCategory(category);
                        },
                      ),
                    );
                  },
                ),
              ),

              // Active Filter Chips Indicator Bar
              if (watchProvider.selectedCategory != 'All' ||
                  watchProvider.selectedBrand != 'All' ||
                  watchProvider.searchQuery.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Text('Active Filters: ',
                          style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              if (watchProvider.selectedCategory != 'All')
                                _buildFilterBadge('Category: ${watchProvider.selectedCategory}', () {
                                  watchProvider.setCategory('All');
                                }),
                              if (watchProvider.selectedBrand != 'All')
                                _buildFilterBadge('Brand: ${watchProvider.selectedBrand}', () {
                                  watchProvider.setBrand('All');
                                }),
                              if (watchProvider.searchQuery.isNotEmpty)
                                _buildFilterBadge('Query: "${watchProvider.searchQuery}"', () {
                                  _searchController.clear();
                                  watchProvider.setSearchQuery('');
                                }),
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _searchController.clear();
                          watchProvider.resetFilters();
                        },
                        child: const Text('Clear', style: TextStyle(color: AppTheme.goldAccent, fontSize: 11)),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 4),

              // Watch Grid Results
              Expanded(
                child: filteredList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off_outlined, color: AppTheme.textMuted, size: 64),
                            const SizedBox(height: 16),
                            const Text(
                              'No Timepieces Found',
                              style: TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Try adjusting your search filters or category.',
                              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                _searchController.clear();
                                watchProvider.resetFilters();
                              },
                              child: const Text('RESET ALL FILTERS'),
                            ),
                          ],
                        ),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final screenWidth = constraints.maxWidth;
                          final crossAxisCount = screenWidth > 1200
                              ? 5
                              : (screenWidth > 900 ? 4 : (screenWidth > 600 ? 3 : 2));
                          
                          // Calculate childAspectRatio dynamically so cards are exactly 280 logical pixels high
                          const double padding = 32.0; // 16.0 * 2 padding (padding: const EdgeInsets.all(16) in GridView)
                          final double spacing = (crossAxisCount - 1) * 14.0;
                          final double cardWidth = (screenWidth - padding - spacing) / crossAxisCount;
                          const double targetHeight = 280.0;
                          final double childAspectRatio = cardWidth / targetHeight;

                          return GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              childAspectRatio: childAspectRatio,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                            ),
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final watch = filteredList[index];
                              final isSelected = _selectedCompareList.contains(watch);
                              return Stack(
                                children: [
                                  WatchCard(
                                    watch: watch,
                                    isSelected: isSelected,
                                    onTap: () {
                                      if (_isCompareMode) {
                                        setState(() {
                                          if (isSelected) {
                                            _selectedCompareList.remove(watch);
                                          } else {
                                            if (_selectedCompareList.length < 3) {
                                              _selectedCompareList.add(watch);
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('You can compare up to 3 timepieces side-by-side.'),
                                                  behavior: SnackBarBehavior.floating,
                                                ),
                                              );
                                            }
                                          }
                                        });
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProductDetailsScreen(watchId: watch.id),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  if (_isCompareMode)
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: isSelected ? AppTheme.goldAccent : Colors.black54,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: AppTheme.goldAccent, width: 2),
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: Icon(
                                          isSelected ? Icons.check : Icons.add,
                                          size: 14,
                                          color: isSelected ? AppTheme.obsidianBlack : AppTheme.goldAccent,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),

          // Floating Comparison Tray
          if (_selectedCompareList.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: const BoxDecoration(
                  color: AppTheme.darkCharcoal,
                  border: Border(top: BorderSide(color: AppTheme.goldAccent, width: 2)),
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _selectedCompareList.length,
                            itemBuilder: (trayCtx, trayIdx) {
                              final w = _selectedCompareList[trayIdx];
                              return Container(
                                margin: const EdgeInsets.only(right: 12),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(w.imageUrls.first, width: 50, height: 50, fit: BoxFit.cover),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedCompareList.remove(w);
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: const BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.close, size: 10, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          backgroundColor: _selectedCompareList.length >= 2 ? AppTheme.goldAccent : Colors.grey.shade800,
                          foregroundColor: _selectedCompareList.length >= 2 ? AppTheme.obsidianBlack : Colors.white,
                        ),
                        onPressed: _selectedCompareList.length >= 2
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ComparisonScreen(watches: _selectedCompareList),
                                  ),
                                );
                              }
                            : null,
                        child: Text(
                          'COMPARE (${_selectedCompareList.length}/3)',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterBadge(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.darkCharcoal,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.goldAccent.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.goldAccent, fontSize: 11)),
          const SizedBox(width: 4),
          InkWell(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 12, color: AppTheme.goldAccent),
          ),
        ],
      ),
    );
  }
}
