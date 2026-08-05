import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/watch.dart';

class WishlistProvider with ChangeNotifier {
  final List<Watch> _wishlist = [];
  String? _userId;
  bool _isLoading = false;

  // NOTE: "collections" (folders within the wishlist) are a frontend-only
  // grouping — the backend only stores a flat per-user wishlist. Collection
  // membership lives in local state and isn't persisted server-side.
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

  List<Watch> get items => List.unmodifiable(_wishlist);
  int get itemCount => _wishlist.length;
  List<String> get collections => List.unmodifiable(_collectionNames);
  bool get isLoading => _isLoading;

  bool isWishlisted(String watchId) {
    return _wishlist.any((w) => w.id == watchId);
  }

  List<Watch> getCollectionWatches(String collectionName) {
    final watchIds = _collectionItems[collectionName] ?? [];
    return _wishlist.where((watch) => watchIds.contains(watch.id)).toList();
  }

  /// Loads the signed-in user's wishlist from the backend, resolving each
  /// watchId against [allWatches] (the loaded catalog).
  Future<void> loadWishlist(String userId, List<Watch> allWatches) async {
    _userId = userId;
    _isLoading = true;
    notifyListeners();

    try {
      final response =
          await http.get(Uri.parse('${ApiConfig.baseUrl}/wishlist/$userId'));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> data = jsonDecode(response.body);
        _wishlist.clear();
        _collectionItems['All Favorites'] = [];

        for (final raw in data) {
          Watch? watch;
          try {
            watch = allWatches.firstWhere((w) => w.id == raw['watchId']);
          } catch (_) {
            watch = null; // watch no longer in catalog, skip
          }
          if (watch == null) continue;

          _wishlist.add(watch);
          _collectionItems['All Favorites']?.add(watch.id);
        }
      }
    } catch (e) {
      debugPrint('Load Wishlist Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleWishlist(Watch watch) async {
    if (_userId == null) return;
    final index = _wishlist.indexWhere((w) => w.id == watch.id);

    if (index >= 0) {
      // Optimistic remove
      _wishlist.removeAt(index);
      _collectionItems.forEach((key, value) => value.remove(watch.id));
      notifyListeners();

      try {
        await http.delete(
            Uri.parse('${ApiConfig.baseUrl}/wishlist/$_userId/${watch.id}'));
      } catch (e) {
        debugPrint('Remove Wishlist Error: $e');
      }
    } else {
      // Optimistic add
      _wishlist.add(watch);
      _collectionItems['All Favorites']?.add(watch.id);
      notifyListeners();

      try {
        final response = await http.post(
          Uri.parse('${ApiConfig.baseUrl}/wishlist'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'userId': _userId, 'watchId': watch.id}),
        );

        if (response.statusCode < 200 || response.statusCode >= 300) {
          // Server rejected it (e.g. already existed) — revert
          _wishlist.removeWhere((w) => w.id == watch.id);
          _collectionItems.forEach((key, value) => value.remove(watch.id));
          notifyListeners();
        }
      } catch (e) {
        debugPrint('Add Wishlist Error: $e');
      }
    }
  }

  Future<void> removeFromWishlist(String watchId) async {
    _wishlist.removeWhere((w) => w.id == watchId);
    _collectionItems.forEach((key, list) {
      list.remove(watchId);
    });
    notifyListeners();

    if (_userId != null) {
      try {
        await http.delete(
            Uri.parse('${ApiConfig.baseUrl}/wishlist/$_userId/$watchId'));
      } catch (e) {
        debugPrint('Remove Wishlist Error: $e');
      }
    }
  }

  /// Clears the local wishlist/collections. There's no bulk-clear endpoint
  /// on the backend, so each item is removed individually server-side too.
  Future<void> clearWishlist() async {
    final idsToRemove = _wishlist.map((w) => w.id).toList();
    _wishlist.clear();
    _collectionItems.forEach((key, list) {
      list.clear();
    });
    notifyListeners();

    if (_userId != null) {
      for (final watchId in idsToRemove) {
        try {
          await http.delete(
              Uri.parse('${ApiConfig.baseUrl}/wishlist/$_userId/$watchId'));
        } catch (e) {
          debugPrint('Clear Wishlist Error: $e');
        }
      }
    }
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

  /// Adds [watch] to a local collection. If it isn't already wishlisted,
  /// this also adds it to the synced wishlist on the backend.
  void addWatchToCollection(String collectionName, Watch watch) {
    if (!_collectionItems.containsKey(collectionName)) return;
    if (_collectionItems[collectionName]!.contains(watch.id)) return;

    _collectionItems[collectionName]!.add(watch.id);
    if (!isWishlisted(watch.id)) {
      _wishlist.add(watch);
      _collectionItems['All Favorites']?.add(watch.id);
      if (_userId != null) {
        _syncAddToWishlist(watch.id);
      }
    }
    notifyListeners();
  }

  Future<void> _syncAddToWishlist(String watchId) async {
    try {
      await http.post(
        Uri.parse('${ApiConfig.baseUrl}/wishlist'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': _userId, 'watchId': watchId}),
      );
    } catch (e) {
      debugPrint('Add Wishlist Error: $e');
    }
  }

  void removeWatchFromCollection(String collectionName, String watchId) {
    if (!_collectionItems.containsKey(collectionName)) return;

    _collectionItems[collectionName]!.remove(watchId);
    if (collectionName == 'All Favorites') {
      removeFromWishlist(watchId);
      return;
    }
    notifyListeners();
  }

  void reset() {
    _wishlist.clear();
    _collectionItems.forEach((key, list) => list.clear());
    _userId = null;
    notifyListeners();
  }
}