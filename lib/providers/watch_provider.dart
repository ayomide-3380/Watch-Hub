import 'package:flutter/material.dart';
import '../models/watch.dart';
import '../models/mock_data.dart';

enum SortOption {
  featured,
  priceLowToHigh,
  priceHighToLow,
  popularity,
  rating,
}

class WatchProvider with ChangeNotifier {
  final List<Watch> _watches = List.from(MockData.watches);
  String _selectedCategory = 'All';
  String _selectedBrand = 'All';
  String _searchQuery = '';
  RangeValues _priceRange = const RangeValues(0, 60000);
  SortOption _sortBy = SortOption.featured;
  final List<String> _recentlyViewedWatchIds = [];

  // Advanced Filters
  String _selectedMovement = 'All';
  double _selectedDiameter = 46.0;

  List<Watch> get allWatches => List.unmodifiable(_watches);
  String get selectedCategory => _selectedCategory;
  String get selectedBrand => _selectedBrand;
  String get searchQuery => _searchQuery;
  RangeValues get priceRange => _priceRange;
  SortOption get sortBy => _sortBy;
  String get selectedMovement => _selectedMovement;
  double get selectedDiameter => _selectedDiameter;
  
  List<Watch> get recentlyViewedWatches => _recentlyViewedWatchIds
      .map((id) => getWatchById(id))
      .whereType<Watch>()
      .toList();

  void addToRecentlyViewed(String id) {
    if (id.isEmpty) return;
    _recentlyViewedWatchIds.remove(id);
    _recentlyViewedWatchIds.insert(0, id);
    if (_recentlyViewedWatchIds.length > 6) {
      _recentlyViewedWatchIds.removeLast();
    }
    notifyListeners();
  }

  List<Watch> get featuredWatches =>
      _watches.where((w) => w.isFeatured).toList();
  List<Watch> get popularWatches =>
      _watches.where((w) => w.isPopular).toList();
  List<Watch> get newArrivals =>
      _watches.where((w) => w.isNewArrival).toList();

  List<Watch> get filteredWatches {
    return _watches.where((watch) {
      final matchesCategory = _selectedCategory == 'All' ||
          watch.category.toLowerCase() == _selectedCategory.toLowerCase();

      final matchesBrand = _selectedBrand == 'All' ||
          watch.brand.toLowerCase() == _selectedBrand.toLowerCase();

      final matchesSearch = _searchQuery.isEmpty ||
          watch.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          watch.brand.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          watch.description.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesPrice = watch.price >= _priceRange.start &&
          watch.price <= _priceRange.end;

      final matchesMovement = _selectedMovement == 'All' ||
          watch.type.toLowerCase().contains(_selectedMovement.toLowerCase()) ||
          (watch.specifications['Movement'] ?? '').toLowerCase().contains(_selectedMovement.toLowerCase());

      final sizeStr = watch.specifications['Case Diameter'] ?? '';
      final diameter = double.tryParse(sizeStr.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 40.0;
      final matchesDiameter = diameter <= _selectedDiameter;

      return matchesCategory && matchesBrand && matchesSearch && matchesPrice && matchesMovement && matchesDiameter;
    }).toList()
      ..sort((a, b) {
        switch (_sortBy) {
          case SortOption.priceLowToHigh:
            return a.price.compareTo(b.price);
          case SortOption.priceHighToLow:
            return b.price.compareTo(a.price);
          case SortOption.popularity:
            return b.reviewCount.compareTo(a.reviewCount);
          case SortOption.rating:
            return b.rating.compareTo(a.rating);
          case SortOption.featured:
            return (b.isFeatured ? 1 : 0).compareTo(a.isFeatured ? 1 : 0);
        }
      });
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setBrand(String brand) {
    _selectedBrand = brand;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setPriceRange(RangeValues range) {
    _priceRange = range;
    notifyListeners();
  }

  void setSortOption(SortOption option) {
    _sortBy = option;
    notifyListeners();
  }

  void setMovement(String movement) {
    _selectedMovement = movement;
    notifyListeners();
  }

  void setDiameter(double diameter) {
    _selectedDiameter = diameter;
    notifyListeners();
  }

  void resetFilters() {
    _selectedCategory = 'All';
    _selectedBrand = 'All';
    _searchQuery = '';
    _priceRange = const RangeValues(0, 60000);
    _sortBy = SortOption.featured;
    _selectedMovement = 'All';
    _selectedDiameter = 46.0;
    notifyListeners();
  }

  // Admin capabilities
  void updateStock(String watchId, int newStock) {
    final index = _watches.indexWhere((w) => w.id == watchId);
    if (index != -1) {
      _watches[index] = _watches[index].copyWith(stockCount: newStock);
      notifyListeners();
    }
  }

  void addWatch(Watch watch) {
    _watches.insert(0, watch);
    notifyListeners();
  }

  void deleteWatch(String watchId) {
    _watches.removeWhere((w) => w.id == watchId);
    notifyListeners();
  }

  void updateWatch(Watch updatedWatch) {
    final index = _watches.indexWhere((w) => w.id == updatedWatch.id);
    if (index != -1) {
      _watches[index] = updatedWatch;
      notifyListeners();
    }
  }

  Watch? getWatchById(String id) {
    try {
      return _watches.firstWhere((w) => w.id == id);
    } catch (_) {
      return null;
    }
  }
}
