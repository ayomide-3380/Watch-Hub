import 'package:flutter/material.dart';
import '../models/watch.dart';
import '../models/mock_data.dart';

class WishlistProvider with ChangeNotifier {
  final List<Watch> _wishlist = [
    MockData.watches[0],
    MockData.watches[2],
  ];

  final List<String> _collectionNames = [
    'All Favorites',
    'Executive Wear',
    'Diving Grails',
    'Weekend Chrono',
  ];

  final Map<String, List<String>> _collectionItems = {
    'All Favorites': [],
    'Executive Wear': [],
    'Diving Grails': [],
    'Weekend Chrono': [],
  };

  WishlistProvider() {
    _collectionItems['All Favorites'] = [MockData.watches[0].id, MockData.watches[2].id];
    _collectionItems['Executive Wear'] = [MockData.watches[0].id];
    _collectionItems['Weekend Chrono'] = [MockData.watches[2].id];
  }

  List<Watch> get items => List.unmodifiable(_wishlist);
  int get itemCount => _wishlist.length;
  List<String> get collections => List.unmodifiable(_collectionNames);

  bool isWishlisted(String watchId) {
    return _wishlist.any((w) => w.id == watchId);
  }

  List<Watch> getCollectionWatches(String collectionName) {
    final watchIds = _collectionItems[collectionName] ?? [];
    return MockData.watches.where((w) => watchIds.contains(w.id)).toList();
  }

  void toggleWishlist(Watch watch) {
    final index = _wishlist.indexWhere((w) => w.id == watch.id);
    if (index >= 0) {
      _wishlist.removeAt(index);
      _collectionItems.forEach((key, list) {
        list.remove(watch.id);
      });
    } else {
      _wishlist.add(watch);
      _collectionItems['All Favorites']?.add(watch.id);
    }
    notifyListeners();
  }

  void removeFromWishlist(String watchId) {
    _wishlist.removeWhere((w) => w.id == watchId);
    _collectionItems.forEach((key, list) {
      list.remove(watchId);
    });
    notifyListeners();
  }

  void clearWishlist() {
    _wishlist.clear();
    _collectionItems.forEach((key, list) {
      list.clear();
    });
    notifyListeners();
  }

  void addCollection(String name) {
    final cleanName = name.trim();
    if (cleanName.isNotEmpty && !_collectionNames.contains(cleanName)) {
      _collectionNames.add(cleanName);
      _collectionItems[cleanName] = [];
      notifyListeners();
    }
  }

  void removeCollection(String name) {
    if (name != 'All Favorites') {
      _collectionNames.remove(name);
      _collectionItems.remove(name);
      notifyListeners();
    }
  }

  void addWatchToCollection(String collectionName, String watchId) {
    if (_collectionItems.containsKey(collectionName)) {
      if (!_collectionItems[collectionName]!.contains(watchId)) {
        _collectionItems[collectionName]!.add(watchId);
        // Ensure it's in the overall wishlist
        if (!isWishlisted(watchId)) {
          final watch = MockData.watches.firstWhere((w) => w.id == watchId);
          _wishlist.add(watch);
          _collectionItems['All Favorites']?.add(watchId);
        }
        notifyListeners();
      }
    }
  }

  void removeWatchFromCollection(String collectionName, String watchId) {
    if (_collectionItems.containsKey(collectionName)) {
      _collectionItems[collectionName]!.remove(watchId);
      // If removed from All Favorites, remove from wishlist entirely
      if (collectionName == 'All Favorites') {
        _wishlist.removeWhere((w) => w.id == watchId);
        _collectionItems.forEach((key, list) {
          list.remove(watchId);
        });
      }
      notifyListeners();
    }
  }
}
