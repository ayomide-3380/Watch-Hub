class UserProfile {
  final String id;
  String name;
  String email;
  String phone;
  String avatarUrl;
  List<String> shippingAddresses;
  String defaultAddress;
  bool isAdmin;
  int loyaltyPoints;
  String vipStatus;
  List<String> unlockedBadges;
  List<Map<String, String>> savedCards; // List of maps like {'number': '•••• 8812', 'type': 'Amex', 'expiry': '12/29'}

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.shippingAddresses,
    required this.defaultAddress,
    this.isAdmin = false,
    this.loyaltyPoints = 350,
    this.vipStatus = 'Gold',
    required this.unlockedBadges,
    required this.savedCards,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    List<String>? shippingAddresses,
    String? defaultAddress,
    bool? isAdmin,
    int? loyaltyPoints,
    String? vipStatus,
    List<String>? unlockedBadges,
    List<Map<String, String>>? savedCards,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      shippingAddresses: shippingAddresses ?? this.shippingAddresses,
      defaultAddress: defaultAddress ?? this.defaultAddress,
      isAdmin: isAdmin ?? this.isAdmin,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      vipStatus: vipStatus ?? this.vipStatus,
      unlockedBadges: unlockedBadges ?? this.unlockedBadges,
      savedCards: savedCards ?? this.savedCards,
    );
  }
}
