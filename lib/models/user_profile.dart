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
  List<Map<String, String>> savedCards;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.shippingAddresses,
    required this.defaultAddress,
    this.isAdmin = false,
    this.loyaltyPoints = 0,
    this.vipStatus = 'Common',
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

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      avatarUrl: json['avatarURL'] ?? '', // matches backend
      shippingAddresses: json['shippingAddresses'] != null
          ? List<String>.from(json['shippingAddresses'])
          : [],
      defaultAddress: json['defaultAddress'] ?? '',
      isAdmin: json['isAdmin'] ?? false,
      loyaltyPoints: json['loyaltyPoint'] ?? 0, // matches backend
      vipStatus: json['vipStatus'] ?? 'Common',
      unlockedBadges: [],
      savedCards: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatarURL': avatarUrl,          // matches backend
      'shippingAddresses': shippingAddresses,
      'defaultAddress': defaultAddress,
      'isAdmin': isAdmin,
      'loyaltyPoint': loyaltyPoints,   // matches backend
      'vipStatus': vipStatus,
    };
  }
}