import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/user_profile.dart';

class AuthProvider with ChangeNotifier {
  UserProfile? _user;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _errorMessage;

  UserProfile? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);

        _user = UserProfile.fromJson(data);
        _isLoggedIn = true;

        return true;
      } else {
        _errorMessage = response.body.replaceAll('"', '');
        return false;
      }
    } catch (e) {
      debugPrint('Login Error: $e');
      _errorMessage = 'Could not connect to server';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signup(
      String name,
      String email,
      String password,
      ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);

        _user = UserProfile.fromJson(data);
        _isLoggedIn = true;

        return true;
      } else {
        _errorMessage = response.body.replaceAll('"', '');
        return false;
      }
    } catch (e) {
      debugPrint('Signup Error: $e');
      _errorMessage = 'Could not connect to server';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  void addAddress(String address) {
    if (_user == null) return;

    if (!_user!.shippingAddresses.contains(address)) {
      _user!.shippingAddresses.add(address);
      notifyListeners();
    }
  }

  void removeAddress(String address) {
    if (_user == null) return;

    _user!.shippingAddresses.remove(address);

    if (_user!.defaultAddress == address &&
        _user!.shippingAddresses.isNotEmpty) {
      _user!.defaultAddress = _user!.shippingAddresses.first;
    }

    notifyListeners();
  }

  void addCard(Map<String, String> card) {
    if (_user == null) return;

    _user!.savedCards.add(card);
    notifyListeners();
  }

  void removeCard(String cardNumber) {
    if (_user == null) return;

    _user!.savedCards.removeWhere(
      (card) => card['number'] == cardNumber,
    );

    notifyListeners();
  }

  void addPoints(int points) {
    if (_user == null) return;

    _user!.loyaltyPoints += points;

    if (_user!.loyaltyPoints >= 2000) {
      _user!.vipStatus = 'Platinum';
      unlockBadge('Royal Collector');
    } else if (_user!.loyaltyPoints >= 1000) {
      _user!.vipStatus = 'Platinum';
    } else if (_user!.loyaltyPoints >= 500) {
      _user!.vipStatus = 'Gold';
    }

    notifyListeners();
  }

  void unlockBadge(String badge) {
    if (_user == null) return;

    if (!_user!.unlockedBadges.contains(badge)) {
      _user!.unlockedBadges.add(badge);
      notifyListeners();
    }
  }

  /// Re-fetches the signed-in user's profile from the backend. Useful after
  /// a server-side action (like checkout awarding loyalty points) that
  /// changes the user's record without going through updateProfile().
  Future<void> refreshProfile() async {
    if (_user == null) return;

    try {
      final response =
          await http.get(Uri.parse('${ApiConfig.baseUrl}/users/${_user!.id}'));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final fresh = UserProfile.fromJson(jsonDecode(response.body));
        // The backend doesn't store badges/saved cards — keep whatever the
        // client has accumulated locally instead of wiping them out.
        _user = fresh.copyWith(
          unlockedBadges: _user!.unlockedBadges,
          savedCards: _user!.savedCards,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Refresh Profile Error: $e');
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String phone,
    required String defaultAddress,
  }) async {
    if (_user == null) return false;

    try {
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/users/${_user!.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'phone': phone,
          'defaultAddress': defaultAddress,
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);

        _user = UserProfile.fromJson(data);
        notifyListeners();

        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Update Profile Error: $e');
      return false;
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}