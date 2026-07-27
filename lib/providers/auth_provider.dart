import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../models/mock_data.dart';

class AuthProvider with ChangeNotifier {
  UserProfile? _user = MockData.defaultUser;
  bool _isLoggedIn = true;
  bool _isAdminMode = false;

  UserProfile? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  bool get isAdminMode => _isAdminMode;

  void login(String email, String password) {
    _isLoggedIn = true;
    _user = UserProfile(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: email.split('@').first.capitalize(),
      email: email,
      phone: '+1 (555) 019-2831',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=400',
      shippingAddresses: [
        '742 Evergreen Terrace, Suite 4B, New York, NY 10021'
      ],
      defaultAddress: '742 Evergreen Terrace, Suite 4B, New York, NY 10021',
      loyaltyPoints: 350,
      vipStatus: 'Gold',
      unlockedBadges: ['Horology Enthusiast'],
      savedCards: [
        {'number': '•••• 8812', 'type': 'Amex', 'expiry': '12/29'}
      ],
    );
    notifyListeners();
  }

  void signup(String name, String email, String password) {
    _isLoggedIn = true;
    _user = UserProfile(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: '+1 (555) 234-5678',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=400',
      shippingAddresses: [
        '100 Main Street, New York, NY 10001'
      ],
      defaultAddress: '100 Main Street, New York, NY 10001',
      loyaltyPoints: 100,
      vipStatus: 'Silver',
      unlockedBadges: ['Horology Enthusiast'],
      savedCards: [],
    );
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _isAdminMode = false;
    notifyListeners();
  }

  void toggleAdminMode() {
    _isAdminMode = !_isAdminMode;
    notifyListeners();
  }

  void addAddress(String address) {
    if (_user != null) {
      if (!_user!.shippingAddresses.contains(address)) {
        _user!.shippingAddresses.add(address);
      }
      notifyListeners();
    }
  }

  void removeAddress(String address) {
    if (_user != null) {
      _user!.shippingAddresses.remove(address);
      if (_user!.defaultAddress == address && _user!.shippingAddresses.isNotEmpty) {
        _user!.defaultAddress = _user!.shippingAddresses.first;
      }
      notifyListeners();
    }
  }

  void addCard(Map<String, String> card) {
    if (_user != null) {
      _user!.savedCards.add(card);
      notifyListeners();
    }
  }

  void removeCard(String cardNumber) {
    if (_user != null) {
      _user!.savedCards.removeWhere((c) => c['number'] == cardNumber);
      notifyListeners();
    }
  }

  void addPoints(int points) {
    if (_user != null) {
      _user!.loyaltyPoints += points;
      // Upgrade tiers
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
  }

  void unlockBadge(String badge) {
    if (_user != null && !_user!.unlockedBadges.contains(badge)) {
      _user!.unlockedBadges.add(badge);
      notifyListeners();
    }
  }

  void updateProfile({required String name, required String phone, required String defaultAddress}) {
    if (_user != null) {
      _user = _user!.copyWith(
        name: name,
        phone: phone,
        defaultAddress: defaultAddress,
      );
      notifyListeners();
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
