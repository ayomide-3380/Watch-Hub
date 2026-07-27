import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/watch_provider.dart';
import '../../providers/order_provider.dart';
import '../../models/watch.dart';
import '../../models/order.dart';
import '../../theme/app_theme.dart';

import '../../models/mock_data.dart'; // import MockData for brand list

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _orderSearchController = TextEditingController();
  bool _isOptimizing = false;
  bool _isBackingUp = false;
  bool _isMaintenanceMode = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _orderSearchController.dispose();
    super.dispose();
  }

  static const List<Map<String, String>> _curatedWatchImages = [
    {
      'name': 'Cosmograph Daytona',
      'url': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&q=80&w=800',
    },
    {
      'name': 'Speedmaster Professional',
      'url': 'https://images.unsplash.com/photo-1542496658-e33a6d0d50f6?auto=format&fit=crop&q=80&w=800',
    },
    {
      'name': 'Royal Oak Diver',
      'url': 'https://images.unsplash.com/photo-1612817288484-6f916006741a?auto=format&fit=crop&q=80&w=800',
    },
    {
      'name': 'Monaco Chronograph',
      'url': 'https://images.unsplash.com/photo-1524805444758-089113d48a6d?auto=format&fit=crop&q=80&w=800',
    },
    {
      'name': 'Santos de Cartier',
      'url': 'https://images.unsplash.com/photo-1524592094714-0f0654e20314?auto=format&fit=crop&q=80&w=800',
    },
    {
      'name': 'Summit Smartwatch',
      'url': 'https://images.unsplash.com/photo-1539874754764-5a96559165b0?auto=format&fit=crop&q=80&w=800',
    },
    {
      'name': 'Submariner Date',
      'url': 'https://images.unsplash.com/photo-1547996160-01ff60023533?auto=format&fit=crop&q=80&w=800',
    },
    {
      'name': 'Grand Complications',
      'url': 'https://images.unsplash.com/photo-1522312346375-d1a52e2b99b3?auto=format&fit=crop&q=80&w=800',
    },
    {
      'name': 'Portugieser Classic',
      'url': 'https://images.unsplash.com/photo-1619134778706-7015533a6150?auto=format&fit=crop&q=80&w=800',
    },
    {
      'name': 'Overseas Automatic',
      'url': 'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&q=80&w=800',
    },
    {
      'name': 'Watch Ultra 2',
      'url': 'https://images.unsplash.com/photo-1517502884422-41eaaced0168?auto=format&fit=crop&q=80&w=800',
    },
  ];

  void _showAddProductModal(BuildContext context) {
    final titleCtrl = TextEditingController();
    final brandCtrl = TextEditingController(text: 'Rolex');
    final priceCtrl = TextEditingController();
    final stockCtrl = TextEditingController(text: '5');
    final descCtrl = TextEditingController();
    String selectedCategory = 'Luxury';
    String? selectedImageUrl;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.darkCharcoal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add New Watch Listing', style: Theme.of(ctx).textTheme.headlineSmall),
                const SizedBox(height: 16),
                TextField(
                  controller: titleCtrl,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(labelText: 'Watch Title / Model'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: brandCtrl,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(labelText: 'Brand Name'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: priceCtrl,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: AppTheme.textPrimary),
                        decoration: const InputDecoration(labelText: 'Price (\$)'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: stockCtrl,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: AppTheme.textPrimary),
                        decoration: const InputDecoration(labelText: 'Initial Stock'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  dropdownColor: AppTheme.cardBg,
                  decoration: const InputDecoration(labelText: 'Category'),
                  style: const TextStyle(color: AppTheme.textPrimary),
                  items: ['Luxury', 'Chronograph', 'Diver', 'Dress', 'Smart'].map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(cat),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setModalState(() {
                        selectedCategory = val;
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  maxLines: 3,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 16),
                
                // Add Picture Section
                const Text('WATCH IMAGE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.goldAccent)),
                const SizedBox(height: 8),
                if (selectedImageUrl == null)
                  InkWell(
                    onTap: () {
                      _showPicturePickerDialog(context, (url) {
                        setModalState(() {
                          selectedImageUrl = url;
                        });
                      });
                    },
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppTheme.darkCharcoal,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.cardBorder, style: BorderStyle.solid),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_outlined, color: AppTheme.goldAccent, size: 30),
                          SizedBox(height: 6),
                          Text('Add Listing Picture', style: TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                        ],
                      ),
                    ),
                  )
                else
                  Stack(
                    children: [
                      Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.goldAccent),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child: Image.network(
                            selectedImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Center(
                              child: Icon(Icons.broken_image, color: AppTheme.errorRed),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: CircleAvatar(
                          backgroundColor: Colors.black54,
                          radius: 16,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.close, color: AppTheme.errorRed, size: 16),
                            onPressed: () {
                              setModalState(() {
                                selectedImageUrl = null;
                              });
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          color: Colors.black54,
                          child: InkWell(
                            onTap: () {
                              _showPicturePickerDialog(context, (url) {
                                setModalState(() {
                                  selectedImageUrl = url;
                                });
                              });
                            },
                            child: const Text('Change Picture', style: TextStyle(color: Colors.white, fontSize: 10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (titleCtrl.text.isNotEmpty && priceCtrl.text.isNotEmpty) {
                        final newWatch = Watch(
                          id: 'w_${DateTime.now().millisecondsSinceEpoch}',
                          title: titleCtrl.text.trim(),
                          brand: brandCtrl.text.trim(),
                          price: double.tryParse(priceCtrl.text) ?? 15000.0,
                          rating: 5.0,
                          reviewCount: 1,
                          imageUrls: [
                            selectedImageUrl ?? 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&q=80&w=800'
                          ],
                          category: selectedCategory,
                          type: 'Automatic',
                          description: descCtrl.text.trim().isEmpty
                              ? 'Exclusive luxury timepiece listing.'
                              : descCtrl.text.trim(),
                          specifications: {'Movement': 'Swiss Automatic', 'Water Resistance': '100m'},
                          availableColors: ['Black Dial'],
                          availableStraps: ['Stainless Steel'],
                          stockCount: int.tryParse(stockCtrl.text) ?? 5,
                          isNewArrival: true,
                        );

                        ctx.read<WatchProvider>().addWatch(newWatch);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added ${newWatch.title} to store catalog!')),
                        );
                      }
                    },
                    child: const Text('PUBLISH WATCH LISTING'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPicturePickerDialog(BuildContext context, Function(String) onImageSelected) {
    final customUrlCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.darkCharcoal,
        title: const Text('Select Watch Picture', style: TextStyle(color: AppTheme.goldAccent)),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: customUrlCtrl,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Paste custom watch image URL...',
                  labelText: 'Custom Image URL',
                ),
              ),
              const SizedBox(height: 16),
              const Text('Or select from our premium gallery:', style: TextStyle(color: AppTheme.textMuted, fontSize: 11)),
              const SizedBox(height: 10),
              Flexible(
                child: SizedBox(
                  height: 220,
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: _curatedWatchImages.length,
                    itemBuilder: (gridCtx, idx) {
                      final item = _curatedWatchImages[idx];
                      return InkWell(
                        onTap: () {
                          onImageSelected(item['url']!);
                          Navigator.pop(ctx);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(item['url']!, fit: BoxFit.cover),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  color: Colors.black54,
                                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                  child: Text(
                                    item['name']!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 8, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('CANCEL', style: TextStyle(color: AppTheme.textMuted)),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            child: const Text('USE CUSTOM URL'),
            onPressed: () {
              if (customUrlCtrl.text.isNotEmpty) {
                onImageSelected(customUrlCtrl.text.trim());
                Navigator.pop(ctx);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    final watchProvider = Provider.of<WatchProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    final watches = watchProvider.allWatches;
    final orders = orderProvider.orders;
    final totalRevenue = orders.fold(0.0, (sum, o) => sum + o.totalAmount);
    final lowStockCount = watches.where((w) => w.stockCount <= 3).length;

    // Filter orders based on search query
    final filteredOrders = orders.where((o) {
      final query = _orderSearchController.text.toLowerCase();
      return query.isEmpty ||
          o.id.toLowerCase().contains(query) ||
          o.shippingAddress.toLowerCase().contains(query);
    }).toList();

    // Brand revenue and sales units calculation
    final Map<String, double> brandRevMap = {};
    final Map<String, int> brandSalesMap = {};
    for (var brand in MockData.brands) {
      brandRevMap[brand] = 0.0;
      brandSalesMap[brand] = 0;
    }
    for (var order in orders) {
      for (var item in order.items) {
        final b = item.watch.brand;
        brandSalesMap[b] = (brandSalesMap[b] ?? 0) + item.quantity;
        brandRevMap[b] = (brandRevMap[b] ?? 0.0) + (item.quantity * item.watch.price);
      }
    }
    // Sort brands by revenue
    final sortedBrands = MockData.brands.toList()
      ..sort((a, b) => (brandRevMap[b] ?? 0.0).compareTo(brandRevMap[a] ?? 0.0));
    final double maxBrandRev = brandRevMap.values.fold(0.0, (max, val) => val > max ? val : max);

    // Category sales calculation
    final Map<String, int> categorySalesMap = {
      'Luxury': 0,
      'Chronograph': 0,
      'Diver': 0,
      'Dress': 0,
      'Smart': 0,
    };
    for (var order in orders) {
      for (var item in order.items) {
        final c = item.watch.category;
        categorySalesMap[c] = (categorySalesMap[c] ?? 0) + item.quantity;
      }
    }
    final int maxCategorySales = categorySalesMap.values.fold(0, (max, val) => val > max ? val : max);

    // Stock distribution counts
    final outOfStockCount = watches.where((w) => w.stockCount == 0).length;
    final lowStockDistributionCount = watches.where((w) => w.stockCount > 0 && w.stockCount <= 3).length;
    final healthyStockCount = watches.where((w) => w.stockCount > 3).length;

    return Scaffold(
      backgroundColor: AppTheme.obsidianBlack,
      appBar: AppBar(
        title: const Text('ADMIN CONTROL CENTER'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppTheme.goldAccent),
            tooltip: 'Add Listing',
            onPressed: () => _showAddProductModal(context),
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.goldAccent,
          labelColor: AppTheme.goldAccent,
          unselectedLabelColor: AppTheme.textMuted,
          tabs: const [
            Tab(icon: Icon(Icons.inventory_2_outlined), text: 'INVENTORY'),
            Tab(icon: Icon(Icons.receipt_long_outlined), text: 'CUSTOMER ORDERS'),
            Tab(icon: Icon(Icons.analytics_outlined), text: 'STORE ANALYTICS'),
          ],
        ),
      ),
      body: Column(
        children: [
          // KPI Metric Banner
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.darkCharcoal,
            child: Row(
              children: [
                _buildKpiCard('Total Models', '${watches.length}', Icons.watch),
                _buildKpiCard('Low Stock', '$lowStockCount', Icons.warning_amber, isAlert: lowStockCount > 0),
                _buildKpiCard('Total Revenue', currencyFormat.format(totalRevenue), Icons.attach_money),
              ],
            ),
          ),

          // Tab View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 1. Inventory Management List
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: watches.length,
                  itemBuilder: (context, index) {
                    final watch = watches[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    watch.imageUrls.first,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      width: 60,
                                      height: 60,
                                      color: AppTheme.darkCharcoal,
                                      child: const Icon(Icons.watch, color: AppTheme.goldAccent),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(watch.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Brand: ${watch.brand} | Category: ${watch.category}',
                                        style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        currencyFormat.format(watch.price),
                                        style: const TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                                // Stock Level Pill
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: watch.stockCount == 0
                                        ? AppTheme.errorRed.withOpacity(0.15)
                                        : (watch.stockCount <= 3
                                            ? Colors.orange.withOpacity(0.15)
                                            : AppTheme.successGreen.withOpacity(0.15)),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: watch.stockCount == 0
                                          ? AppTheme.errorRed
                                          : (watch.stockCount <= 3 ? Colors.orange : AppTheme.successGreen),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    watch.stockCount == 0
                                        ? 'OUT OF STOCK'
                                        : (watch.stockCount <= 3 ? 'LOW STOCK' : 'IN STOCK'),
                                    style: TextStyle(
                                      color: watch.stockCount == 0
                                          ? AppTheme.errorRed
                                          : (watch.stockCount <= 3 ? Colors.orange : AppTheme.successGreen),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(color: AppTheme.cardBorder, height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Stock Adjuster Box
                                Row(
                                  children: [
                                    const Text('Stock: ', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                                    const SizedBox(width: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppTheme.darkCharcoal,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: AppTheme.cardBorder),
                                      ),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            visualDensity: VisualDensity.compact,
                                            icon: const Icon(Icons.remove, size: 14, color: AppTheme.textPrimary),
                                            onPressed: () {
                                              if (watch.stockCount > 0) {
                                                watchProvider.updateStock(watch.id, watch.stockCount - 1);
                                              }
                                            },
                                          ),
                                          Text(
                                            '${watch.stockCount}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: watch.stockCount <= 3 ? AppTheme.errorRed : AppTheme.goldAccent,
                                            ),
                                          ),
                                          IconButton(
                                            visualDensity: VisualDensity.compact,
                                            icon: const Icon(Icons.add, size: 14, color: AppTheme.textPrimary),
                                            onPressed: () {
                                              watchProvider.updateStock(watch.id, watch.stockCount + 1);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                // Edit & Delete Actions
                                Row(
                                  children: [
                                    OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                        minimumSize: Size.zero,
                                        side: const BorderSide(color: AppTheme.goldAccent),
                                      ),
                                      icon: const Icon(Icons.edit_outlined, size: 14, color: AppTheme.goldAccent),
                                      label: const Text('EDIT', style: TextStyle(fontSize: 11, color: AppTheme.goldAccent)),
                                      onPressed: () => _showEditProductModal(context, watch),
                                    ),
                                    const SizedBox(width: 8),
                                    OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                        minimumSize: Size.zero,
                                        side: const BorderSide(color: AppTheme.errorRed),
                                      ),
                                      icon: const Icon(Icons.delete_outline, size: 14, color: AppTheme.errorRed),
                                      label: const Text('DELETE', style: TextStyle(fontSize: 11, color: AppTheme.errorRed)),
                                      onPressed: () => _showDeleteConfirmation(context, watch, watchProvider),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // 2. Order Status Management List with Search and Tappable Details Dialog
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: TextField(
                        controller: _orderSearchController,
                        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Search orders by ID or customer address...',
                          prefixIcon: const Icon(Icons.search, color: AppTheme.goldAccent),
                          suffixIcon: _orderSearchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, color: AppTheme.textMuted),
                                  onPressed: () {
                                    setState(() {
                                      _orderSearchController.clear();
                                    });
                                  },
                                )
                              : null,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onChanged: (val) {
                          setState(() {}); // trigger rebuild to filter list
                        },
                      ),
                    ),
                    Expanded(
                      child: filteredOrders.isEmpty
                          ? const Center(
                              child: Text('No orders match your search criteria.', style: TextStyle(color: AppTheme.textMuted)),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: filteredOrders.length,
                              itemBuilder: (context, index) {
                                final order = filteredOrders[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: () => _showOrderDetailsDialog(context, order, currencyFormat),
                                    child: Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text('ORDER #${order.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                                  const SizedBox(width: 8),
                                                  const Icon(Icons.info_outline, size: 14, color: AppTheme.textMuted),
                                                ],
                                              ),
                                              Text(currencyFormat.format(order.totalAmount), style: const TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text('Customer Address: ${order.shippingAddress}', style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                                          const SizedBox(height: 12),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Update Status: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                              DropdownButton<OrderStatus>(
                                                value: order.status,
                                                dropdownColor: AppTheme.cardBg,
                                                style: const TextStyle(color: AppTheme.goldAccent, fontSize: 12, fontWeight: FontWeight.bold),
                                                items: OrderStatus.values.map((st) {
                                                  return DropdownMenuItem(
                                                    value: st,
                                                    child: Text(st.name.toUpperCase()),
                                                  );
                                                }).toList(),
                                                onChanged: (newStatus) {
                                                  if (newStatus != null) {
                                                    orderProvider.updateOrderStatus(order.id, newStatus);
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),

                // 3. Store Analytics Tab (NEW!)
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stock Health distribution card
                      Text('STOCK HEALTH DISTRIBUTION', style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              _buildStockStatusIndicator('Healthy (>3)', healthyStockCount, AppTheme.successGreen),
                              _buildStockStatusIndicator('Low (1-3)', lowStockDistributionCount, Colors.orange),
                              _buildStockStatusIndicator('Out of Stock', outOfStockCount, AppTheme.errorRed),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Revenue by Brand card
                      Text('REVENUE CONTRIBUTION BY BRAND', style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: sortedBrands.map((brand) {
                              final rev = brandRevMap[brand] ?? 0.0;
                              final sales = brandSalesMap[brand] ?? 0;
                              final double percent = maxBrandRev > 0 ? rev / maxBrandRev : 0.0;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(brand, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                        Text('${currencyFormat.format(rev)} ($sales units)', style: const TextStyle(color: AppTheme.goldAccent, fontSize: 12)),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: percent,
                                        backgroundColor: AppTheme.darkCharcoal,
                                        color: AppTheme.goldAccent,
                                        minHeight: 6,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Unit Sales by Category
                      Text('UNIT SALES BY CATEGORY', style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: categorySalesMap.entries.map((entry) {
                              final cat = entry.key;
                              final sales = entry.value;
                              final double percent = maxCategorySales > 0 ? sales / maxCategorySales : 0.0;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(cat, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                        Text('$sales units', style: const TextStyle(color: AppTheme.roseGold, fontSize: 12)),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: percent,
                                        backgroundColor: AppTheme.darkCharcoal,
                                        color: AppTheme.roseGold,
                                        minHeight: 6,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // System Operations Control Card
                      Text('SYSTEM OPERATIONS CONTROL', style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Perform simulated administrative operations on the WatchHub listing databases and registry caches.',
                                style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
                              ),
                              const SizedBox(height: 16),
                              
                              // Re-index database
                              Row(
                                children: [
                                  Expanded(
                                    child: _isOptimizing 
                                        ? const Center(child: SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: AppTheme.goldAccent)))
                                        : ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.darkCharcoal, foregroundColor: AppTheme.goldAccent),
                                            icon: const Icon(Icons.bolt, size: 16),
                                            label: const Text('RE-INDEX DATABASE', style: TextStyle(fontSize: 11)),
                                            onPressed: () {
                                              final messenger = ScaffoldMessenger.of(context);
                                              setState(() => _isOptimizing = true);
                                              Future.delayed(const Duration(milliseconds: 1500), () {
                                                if (mounted) {
                                                  setState(() => _isOptimizing = false);
                                                  messenger.showSnackBar(
                                                    const SnackBar(
                                                      content: Row(
                                                        children: [
                                                          Icon(Icons.check_circle, color: AppTheme.successGreen),
                                                          SizedBox(width: 8),
                                                          Text('Database optimized! All listing index metrics rebuilt.'),
                                                        ],
                                                      ),
                                                      behavior: SnackBarBehavior.floating,
                                                    ),
                                                  );
                                                }
                                              });
                                            },
                                          ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Secure Backup
                              Row(
                                children: [
                                  Expanded(
                                    child: _isBackingUp 
                                        ? const Center(child: SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: AppTheme.goldAccent)))
                                        : ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.darkCharcoal, foregroundColor: AppTheme.roseGold),
                                            icon: const Icon(Icons.backup_outlined, size: 16),
                                            label: const Text('BACKUP STORE REGISTRY', style: TextStyle(fontSize: 11)),
                                            onPressed: () {
                                              setState(() => _isBackingUp = true);
                                              Future.delayed(const Duration(milliseconds: 1200), () {
                                                if (mounted) {
                                                  setState(() => _isBackingUp = false);
                                                  if (!context.mounted) return;
                                                  showDialog(
                                                    context: context,
                                                    builder: (ctx) => AlertDialog(
                                                      backgroundColor: AppTheme.cardBg,
                                                      title: const Row(
                                                        children: [
                                                          Icon(Icons.cloud_done, color: AppTheme.goldAccent),
                                                          SizedBox(width: 8),
                                                          Text('Registry Backup Done'),
                                                        ],
                                                      ),
                                                      content: Text('WatchHub store catalog registry and customer orders database backed up. Backup file written:\n\nWH_BACKUP_CATALOG_${DateTime.now().millisecondsSinceEpoch}.json\n\nEncryption: AES-256 Cloud Vault Secure.'),
                                                      actions: [
                                                        ElevatedButton(
                                                          child: const Text('OK'),
                                                          onPressed: () => Navigator.pop(ctx),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }
                                              });
                                            },
                                          ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Maintenance Mode Toggle
                              Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: _isMaintenanceMode ? AppTheme.successGreen : AppTheme.errorRed,
                                          side: BorderSide(color: _isMaintenanceMode ? AppTheme.successGreen : AppTheme.errorRed),
                                        ),
                                        icon: Icon(_isMaintenanceMode ? Icons.check_circle_outline : Icons.power_settings_new, size: 16),
                                        label: Text(_isMaintenanceMode ? 'SET STORE ONLINE' : 'ACTIVATE MAINTENANCE MODE', style: const TextStyle(fontSize: 11)),
                                        onPressed: () {
                                          setState(() {
                                            _isMaintenanceMode = !_isMaintenanceMode;
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(_isMaintenanceMode 
                                                  ? 'Store is now in Maintenance Mode. Non-admin users will see offline screen.' 
                                                  : 'Store is now back Online.'),
                                              behavior: SnackBarBehavior.floating,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard(String title, String val, IconData icon, {bool isAlert = false}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isAlert ? AppTheme.errorRed : AppTheme.cardBorder),
        ),
        child: Column(
          children: [
            Icon(icon, color: isAlert ? AppTheme.errorRed : AppTheme.goldAccent, size: 20),
            const SizedBox(height: 4),
            Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textPrimary)),
            Text(title, style: const TextStyle(color: AppTheme.textMuted, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildStockStatusIndicator(String label, int count, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text('$count', style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 10)),
        ],
      ),
    );
  }

  void _showEditProductModal(BuildContext context, Watch watch) {
    final titleCtrl = TextEditingController(text: watch.title);
    final brandCtrl = TextEditingController(text: watch.brand);
    final priceCtrl = TextEditingController(text: watch.price.toStringAsFixed(0));
    final stockCtrl = TextEditingController(text: watch.stockCount.toString());
    final descCtrl = TextEditingController(text: watch.description);
    String selectedCategory = watch.category;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.darkCharcoal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Edit Watch Listing', style: Theme.of(ctx).textTheme.headlineSmall),
                const SizedBox(height: 16),
                TextField(
                  controller: titleCtrl,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(labelText: 'Watch Title / Model'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: brandCtrl,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(labelText: 'Brand Name'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: priceCtrl,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: AppTheme.textPrimary),
                        decoration: const InputDecoration(labelText: 'Price (\$)'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: stockCtrl,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: AppTheme.textPrimary),
                        decoration: const InputDecoration(labelText: 'Stock Count'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  dropdownColor: AppTheme.cardBg,
                  decoration: const InputDecoration(labelText: 'Category'),
                  style: const TextStyle(color: AppTheme.textPrimary),
                  items: ['Luxury', 'Chronograph', 'Diver', 'Dress', 'Smart'].map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(cat),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setModalState(() {
                        selectedCategory = val;
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  maxLines: 3,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (titleCtrl.text.isNotEmpty && priceCtrl.text.isNotEmpty) {
                        final updatedWatch = watch.copyWith(
                          title: titleCtrl.text.trim(),
                          brand: brandCtrl.text.trim(),
                          price: double.tryParse(priceCtrl.text) ?? watch.price,
                          stockCount: int.tryParse(stockCtrl.text) ?? watch.stockCount,
                          category: selectedCategory,
                          description: descCtrl.text.trim(),
                        );

                        context.read<WatchProvider>().updateWatch(updatedWatch);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Updated ${updatedWatch.title}!')),
                        );
                      }
                    },
                    child: const Text('SAVE LISTING CHANGES'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Watch watch, WatchProvider watchProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardBg,
        title: const Text('Delete Watch Listing?', style: TextStyle(color: AppTheme.errorRed)),
        content: Text('Are you sure you want to permanently delete "${watch.title}" from the catalog? This action cannot be undone.'),
        actions: [
          TextButton(
            child: const Text('CANCEL', style: TextStyle(color: AppTheme.textMuted)),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorRed, foregroundColor: Colors.white),
            child: const Text('DELETE'),
            onPressed: () {
              watchProvider.deleteWatch(watch.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Deleted ${watch.title} from store catalog.')),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showOrderDetailsDialog(BuildContext context, Order order, NumberFormat currencyFormat) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppTheme.darkCharcoal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ORDER DETAILS', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.goldAccent)),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppTheme.textMuted),
                      onPressed: () => Navigator.pop(ctx),
                    )
                  ],
                ),
                const Divider(color: AppTheme.cardBorder),
                const SizedBox(height: 10),
                _buildDetailRow('Order ID', '#${order.id}'),
                _buildDetailRow('Date', DateFormat('yMMMd').add_jm().format(order.orderDate)),
                _buildDetailRow('Payment Method', order.paymentMethod),
                _buildDetailRow('Shipping Address', order.shippingAddress),
                const SizedBox(height: 16),
                const Text('ITEMS ORDERED', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.goldAccent)),
                const SizedBox(height: 8),
                Column(
                  children: order.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${item.watch.title} (${item.selectedColor}, ${item.selectedStrap})',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          Text(
                            '${item.quantity} x ${currencyFormat.format(item.watch.price)}',
                            style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Divider(color: AppTheme.cardBorder),
                const SizedBox(height: 8),
                _buildPriceRow('Subtotal', currencyFormat.format(order.subtotal)),
                _buildPriceRow('Tax (8%)', currencyFormat.format(order.tax)),
                _buildPriceRow('Shipping (Armored Courier)', currencyFormat.format(order.shippingFee)),
                if (order.discount > 0)
                  _buildPriceRow('Discount', '-${currencyFormat.format(order.discount)}', isDiscount: true),
                const Divider(color: AppTheme.cardBorder),
                _buildPriceRow('Total Amount', currencyFormat.format(order.totalAmount), isBold: true, color: AppTheme.goldAccent),
                const SizedBox(height: 20),
                const Text('TRACKING LOG', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.goldAccent)),
                const SizedBox(height: 10),
                Column(
                  children: order.trackingSteps.map((step) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Icon(
                              step.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                              color: step.isCompleted ? AppTheme.successGreen : AppTheme.textMuted,
                              size: 16,
                            ),
                            Container(
                              width: 2,
                              height: 24,
                              color: AppTheme.cardBorder,
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(step.title, style: TextStyle(fontSize: 12, fontWeight: step.isCompleted ? FontWeight.bold : FontWeight.normal)),
                              Text(step.description, style: const TextStyle(color: AppTheme.textMuted, fontSize: 10)),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String val, {bool isBold = false, bool isDiscount = false, Color? color}) {
    final style = TextStyle(
      fontSize: isBold ? 14 : 12,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      color: color ?? (isDiscount ? AppTheme.roseGold : AppTheme.textPrimary),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(val, style: style),
        ],
      ),
    );
  }
}
