import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/watch_card.dart';
import '../product_details/product_details_screen.dart';

class WishlistScreen extends StatefulWidget {
  final VoidCallback onNavigateToCatalog;

  const WishlistScreen({super.key, required this.onNavigateToCatalog});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  String _selectedCollection = 'All Favorites';
  final _collectionNameCtrl = TextEditingController();

  @override
  void dispose() {
    _collectionNameCtrl.dispose();
    super.dispose();
  }

  void _showAddCollectionDialog(BuildContext context, WishlistProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.darkCharcoal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('New Wishlist Collection', style: TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.bold, fontSize: 16)),
        content: TextField(
          controller: _collectionNameCtrl,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Collection Name',
            hintText: 'e.g. Dream Grails',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _collectionNameCtrl.clear();
              Navigator.pop(ctx);
            },
            child: const Text('CANCEL', style: TextStyle(color: AppTheme.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              final name = _collectionNameCtrl.text.trim();
              if (name.isNotEmpty) {
                provider.addCollection(name);
                setState(() {
                  _selectedCollection = name;
                });
                _collectionNameCtrl.clear();
                Navigator.pop(ctx);
              }
            },
            child: const Text('CREATE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final collections = wishlistProvider.collections;
    final items = wishlistProvider.getCollectionWatches(_selectedCollection);

    return Scaffold(
      backgroundColor: AppTheme.obsidianBlack,
      appBar: AppBar(
        title: const Text('SAVED WISHLIST'),
        actions: [
          IconButton(
            icon: const Icon(Icons.create_new_folder_outlined, color: AppTheme.goldAccent),
            tooltip: 'Create Collection',
            onPressed: () => _showAddCollectionDialog(context, wishlistProvider),
          ),
          if (wishlistProvider.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppTheme.textMuted),
              tooltip: 'Clear Wishlist',
              onPressed: () => wishlistProvider.clearWishlist(),
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Collection Folders Horizontal selector bar
          Container(
            height: 52,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: collections.length,
              itemBuilder: (ctx, idx) {
                final folder = collections[idx];
                final isSelected = _selectedCollection == folder;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    avatar: Icon(
                      folder == 'All Favorites' ? Icons.favorite : Icons.folder_open_outlined,
                      color: isSelected ? AppTheme.obsidianBlack : AppTheme.goldAccent,
                      size: 14,
                    ),
                    label: Text(folder),
                    selected: isSelected,
                    selectedColor: AppTheme.goldAccent,
                    backgroundColor: AppTheme.cardBg,
                    labelStyle: TextStyle(
                      color: isSelected ? AppTheme.obsidianBlack : AppTheme.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCollection = folder;
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),

          // Items Grid
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.favorite_border, color: AppTheme.textMuted, size: 72),
                        const SizedBox(height: 16),
                        Text('This Collection is Empty', style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 8),
                        const Text(
                          'Save watches to this folder or drag them here later.',
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: widget.onNavigateToCatalog,
                          child: const Text('EXPLORE WATCHES'),
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
                      
                      // Calculate childAspectRatio dynamically
                      const double padding = 32.0;
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
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final watch = items[index];
                          return WatchCard(
                            watch: watch,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailsScreen(watchId: watch.id),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
