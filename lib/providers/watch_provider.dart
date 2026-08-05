import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/watch.dart';

enum SortOption {
  featured,
  priceLowToHigh,
  priceHighToLow,
  popularity,
  rating,
}

class WatchProvider with ChangeNotifier {
  List<Watch> _watches = [];
  bool _isLoading = false;
  String? _errorMessage;

  String _selectedCategory = 'All';
  String _selectedBrand = 'All';
  String _searchQuery = '';
  RangeValues _priceRange = const RangeValues(0, 60000);
  SortOption _sortBy = SortOption.featured;
  final List<String> _recentlyViewedWatchIds = [];

  String _selectedMovement = 'All';
  double _selectedDiameter = 46.0;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Watch> get allWatches => List.unmodifiable(_watches);
  String get selectedCategory => _selectedCategory;
  String get selectedBrand => _selectedBrand;
  String get searchQuery => _searchQuery;
  RangeValues get priceRange => _priceRange;
  SortOption get sortBy => _sortBy;
  String get selectedMovement => _selectedMovement;
  double get selectedDiameter => _selectedDiameter;

  Future<void> loadWatches() async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/watches'),
    );

    debugPrint("Status Code: ${response.statusCode}");
    debugPrint("Response: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      debugPrint("Number of watches: ${data.length}");

      _watches = data.map((json) => Watch.fromJson(json)).toList();

      debugPrint("All watches: ${_watches.length}");
      debugPrint("Featured: ${featuredWatches.length}");
      debugPrint("Popular: ${popularWatches.length}");
      debugPrint("New: ${newArrivals.length}");

      debugPrint("Loaded watches: ${_watches.length}");

      _isLoading = false;
      notifyListeners();
    } else {
      _errorMessage = 'Failed to load watches';
      _isLoading = false;
      notifyListeners();
    }
  } catch (e) {
    debugPrint(e.toString());
    _errorMessage = 'Could not connect to server';
    _isLoading = false;
    notifyListeners();
  }
}

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

  List<Watch> get featuredWatches {
    final list = _watches.where((w) => w.isFeatured).toList();
    return list.isNotEmpty ? list : _watches;
  }
  
  List<Watch> get popularWatches {
    final list = _watches.where((w) => w.isPopular).toList();
    return list.isNotEmpty ? list : _watches;
  }
  
  List<Watch> get newArrivals {
    final list = _watches.where((w) => w.isNewArrival).toList();
    return list.isNotEmpty ? list : _watches;
  }

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
  Future<bool> updateStock(String watchId, int newStock) async {
    final index = _watches.indexWhere((w) => w.id == watchId);
    if (index == -1) return false;

    try {
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/watches/$watchId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'stockCount': newStock}),
      );
      if (response.statusCode == 200) {
        _watches[index] = _watches[index].copyWith(stockCount: newStock);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addWatch(Watch watch) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/watches'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(watch.toJson()),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _watches.insert(0, Watch.fromJson(data));
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteWatch(String watchId) async {
    try {
      final response = await http.delete(Uri.parse('${ApiConfig.baseUrl}/watches/$watchId'));
      if (response.statusCode == 204) {
        _watches.removeWhere((w) => w.id == watchId);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
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