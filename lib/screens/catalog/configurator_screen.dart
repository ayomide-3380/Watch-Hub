import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/cart_provider.dart';
import '../../models/watch.dart';
import '../../theme/app_theme.dart';

class ConfiguratorScreen extends StatefulWidget {
  const ConfiguratorScreen({super.key});

  @override
  State<ConfiguratorScreen> createState() => _ConfiguratorScreenState();
}

class _ConfiguratorScreenState extends State<ConfiguratorScreen> {
  // Config state
  String _selectedStyle = 'Diver Classic';
  String _selectedMetal = 'Oystersteel';
  String _selectedBezel = 'Polished Smooth';
  String _selectedDialColor = 'Classic Black';
  String _selectedStrap = 'Stainless Steel Bracelet';
  bool _isSaving = false;

  // Options Definitions
  final Map<String, double> _baseStyles = {
    'Diver Classic': 8500.0,
    'Minimalist Dress': 5200.0,
    'Heritage Chrono': 12000.0,
  };

  final Map<String, double> _metals = {
    'Oystersteel': 0.0,
    'Grade 5 Titanium': 1500.0,
    '18K Rose Gold': 5500.0,
    '950 Platinum': 12500.0,
  };

  final Map<String, double> _bezels = {
    'Polished Smooth': 0.0,
    'Classic Fluted': 800.0,
    'Rotatable Ceramic Bezel': 1200.0,
  };

  final Map<String, double> _dialColors = {
    'Classic Black': 0.0,
    'Ice Blue': 1000.0,
    'Emerald Green': 500.0,
    'Lacquered Blue': 400.0,
    'Champagne Gold': 800.0,
  };

  final Map<String, double> _straps = {
    'Stainless Steel Bracelet': 0.0,
    'Premium Italian Saffiano Leather': 400.0,
    'Oysterflex Sport Rubber': 600.0,
    'Sleek NATO Nylon': 150.0,
  };

  // Curated style preview image URLs
  final Map<String, String> _styleImages = {
    'Diver Classic': 'https://images.unsplash.com/photo-1612817288484-6f916006741a?auto=format&fit=crop&q=80&w=800',
    'Minimalist Dress': 'https://images.unsplash.com/photo-1522312346375-d1a52e2b99b3?auto=format&fit=crop&q=80&w=800',
    'Heritage Chrono': 'https://images.unsplash.com/photo-1619134778706-7015533a6150?auto=format&fit=crop&q=80&w=800',
  };

  double get _totalPrice {
    return (_baseStyles[_selectedStyle] ?? 0.0) +
        (_metals[_selectedMetal] ?? 0.0) +
        (_bezels[_selectedBezel] ?? 0.0) +
        (_dialColors[_selectedDialColor] ?? 0.0) +
        (_straps[_selectedStrap] ?? 0.0);
  }

  // Helper to map dial colors to real Flutter color tints for dynamic rendering
  Color _getDialColorValue() {
    switch (_selectedDialColor) {
      case 'Ice Blue':
        return Colors.lightBlueAccent.withOpacity(0.18);
      case 'Emerald Green':
        return const Color(0xFF0F7A50).withOpacity(0.18);
      case 'Lacquered Blue':
        return Colors.blue.shade900.withOpacity(0.20);
      case 'Champagne Gold':
        return Colors.amber.shade200.withOpacity(0.18);
      default:
        return Colors.black.withOpacity(0.0);
    }
  }

  Widget _buildConfigSection(String title, List<String> options, String selectedValue, Map<String, double> priceMap, Function(String) onSelected) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2),
          ),
        ),
        SizedBox(
          height: 64,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: options.length,
            itemBuilder: (context, idx) {
              final option = options[idx];
              final isSelected = option == selectedValue;
              final priceAdd = priceMap[option] ?? 0.0;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                child: InkWell(
                  onTap: () => onSelected(option),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.goldAccent.withOpacity(0.1) : AppTheme.cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? AppTheme.goldAccent : AppTheme.cardBorder),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(option, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          if (priceAdd > 0)
                            Text(
                              '+${currencyFormat.format(priceAdd)}',
                              style: const TextStyle(color: AppTheme.goldAccent, fontSize: 10, fontWeight: FontWeight.w500),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    final activeStyleImg = _styleImages[_selectedStyle]!;

    return Scaffold(
      backgroundColor: AppTheme.obsidianBlack,
      appBar: AppBar(
        title: const Text('CUSTOM CONFIGURATOR'),
      ),
      body: Column(
        children: [
          // Dynamic Custom Rendering Preview
          Stack(
            children: [
              Container(
                height: 240,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: const Border(bottom: BorderSide(color: AppTheme.cardBorder)),
                  color: AppTheme.darkCharcoal,
                ),
                child: Image.network(activeStyleImg, fit: BoxFit.cover),
              ),
              // Dynamic Dial Color Overlay Tint
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      color: _getDialColorValue(),
                    ),
                  ),
                ),
              ),
              // Info Overlay Card
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$_selectedMetal | $_selectedDialColor | $_selectedStrap',
                    style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),

          // Scrollable Settings Pane
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  _buildConfigSection(
                    '1. Base Style',
                    _baseStyles.keys.toList(),
                    _selectedStyle,
                    _baseStyles,
                    (val) => setState(() => _selectedStyle = val),
                  ),
                  _buildConfigSection(
                    '2. Metal Case',
                    _metals.keys.toList(),
                    _selectedMetal,
                    _metals,
                    (val) => setState(() => _selectedMetal = val),
                  ),
                  _buildConfigSection(
                    '3. Bezel Design',
                    _bezels.keys.toList(),
                    _selectedBezel,
                    _bezels,
                    (val) => setState(() => _selectedBezel = val),
                  ),
                  _buildConfigSection(
                    '4. Dial Color',
                    _dialColors.keys.toList(),
                    _selectedDialColor,
                    _dialColors,
                    (val) => setState(() => _selectedDialColor = val),
                  ),
                  _buildConfigSection(
                    '5. Strap Option',
                    _straps.keys.toList(),
                    _selectedStrap,
                    _straps,
                    (val) => setState(() => _selectedStrap = val),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Glassmorphic Price Checkout Sheet
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppTheme.darkCharcoal,
              border: Border(top: BorderSide(color: AppTheme.cardBorder)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('TOTAL BESPOKE PRICE', style: TextStyle(color: AppTheme.textMuted, fontSize: 10, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          currencyFormat.format(_totalPrice),
                          style: const TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    height: 48,
                    child: _isSaving 
                        ? const Center(child: CircularProgressIndicator(color: AppTheme.goldAccent))
                        : ElevatedButton(
                            onPressed: () {
                              final cartProvider = context.read<CartProvider>();
                              final messenger = ScaffoldMessenger.of(context);
                              final navigator = Navigator.of(context);

                              setState(() => _isSaving = true);
                              Future.delayed(const Duration(milliseconds: 1000), () {
                                final customWatch = Watch(
                                  id: 'w_custom_${DateTime.now().millisecondsSinceEpoch}',
                                  title: 'Bespoke $_selectedStyle',
                                  brand: 'WatchHub Custom',
                                  price: _totalPrice,
                                  rating: 5.0,
                                  reviewCount: 0,
                                  imageUrls: [activeStyleImg],
                                  category: 'Luxury',
                                  type: 'Bespoke Configured',
                                  description: 'A hand-crafted bespoke timepiece designed with $_selectedMetal, $_selectedBezel bezel, $_selectedDialColor dial, and $_selectedStrap strap.',
                                  specifications: {
                                    'Movement': 'Automatic Calibre WH-99',
                                    'Case Metal': _selectedMetal,
                                    'Bezel': _selectedBezel,
                                    'Strap': _selectedStrap,
                                    'Dial': _selectedDialColor,
                                    'Water Resistance': '100m',
                                  },
                                  availableColors: [_selectedDialColor],
                                  availableStraps: [_selectedStrap],
                                  stockCount: 1,
                                );

                                cartProvider.addToCart(
                                  customWatch, 
                                  color: _selectedDialColor, 
                                  strap: _selectedStrap
                                );

                                if (mounted) {
                                  setState(() => _isSaving = false);
                                  messenger.showSnackBar(
                                    const SnackBar(
                                      content: Row(
                                        children: [
                                          Icon(Icons.check_circle, color: AppTheme.successGreen),
                                          SizedBox(width: 8),
                                          Text('Custom watch added to cart!'),
                                        ],
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  navigator.pop();
                                }
                              });
                            },
                            child: const Text('ADD TO CART'),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


