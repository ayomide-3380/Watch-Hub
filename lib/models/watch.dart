class Watch {
  final String id;
  final String title;
  final String brand;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final List<String> imageUrls;
  final String category;
  final String type;
  final String description;
  final Map<String, String> specifications;
  final List<String> availableColors;
  final List<String> availableStraps;
  int stockCount;
  final bool isPopular;
  final bool isFeatured;
  final bool isNewArrival;

  Watch({
    required this.id,
    required this.title,
    required this.brand,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.imageUrls,
    required this.category,
    required this.type,
    required this.description,
    required this.specifications,
    required this.availableColors,
    required this.availableStraps,
    required this.stockCount,
    this.isPopular = false,
    this.isFeatured = false,
    this.isNewArrival = false,
  });

  bool get isAvailable => stockCount > 0;

  bool get hasDiscount =>
      originalPrice != null && originalPrice! > price;

  int get discountPercentage => hasDiscount
      ? (((originalPrice! - price) / originalPrice!) * 100).round()
      : 0;

  Watch copyWith({
    String? id,
    String? title,
    String? brand,
    double? price,
    double? originalPrice,
    double? rating,
    int? reviewCount,
    List<String>? imageUrls,
    String? category,
    String? type,
    String? description,
    Map<String, String>? specifications,
    List<String>? availableColors,
    List<String>? availableStraps,
    int? stockCount,
    bool? isPopular,
    bool? isFeatured,
    bool? isNewArrival,
  }) {
    return Watch(
      id: id ?? this.id,
      title: title ?? this.title,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      imageUrls: imageUrls ?? this.imageUrls,
      category: category ?? this.category,
      type: type ?? this.type,
      description: description ?? this.description,
      specifications: specifications ?? this.specifications,
      availableColors: availableColors ?? this.availableColors,
      availableStraps: availableStraps ?? this.availableStraps,
      stockCount: stockCount ?? this.stockCount,
      isPopular: isPopular ?? this.isPopular,
      isFeatured: isFeatured ?? this.isFeatured,
      isNewArrival: isNewArrival ?? this.isNewArrival,
    );
  }

  factory Watch.fromJson(Map<String, dynamic> json) {
    return Watch(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      brand: json['brand'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: json['originalPrice'] != null
          ? (json['originalPrice'] as num).toDouble()
          : null,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      imageUrls: json['imageUrls'] != null
          ? List<String>.from(json['imageUrls'])
          : [],
      category: json['category'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      specifications: json['specifications'] != null
          ? Map<String, String>.from(json['specifications'])
          : {},
      availableColors: json['availableColors'] != null
          ? List<String>.from(json['availableColors'])
          : [],
      availableStraps: json['availableStraps'] != null
          ? List<String>.from(json['availableStraps'])
          : [],
      stockCount: (json['stockCount'] as num?)?.toInt() ?? 0,
      isPopular: json['isPopular'] == true,
      isFeatured: json['isFeatured'] == true,
      isNewArrival: json['isNewArrival'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'brand': brand,
      'price': price,
      'originalPrice': originalPrice,
      'rating': rating,
      'reviewCount': reviewCount,
      'imageUrls': imageUrls,
      'category': category,
      'type': type,
      'description': description,
      'specifications': specifications,
      'availableColors': availableColors,
      'availableStraps': availableStraps,
      'stockCount': stockCount,
      'isPopular': isPopular,
      'isFeatured': isFeatured,
      'isNewArrival': isNewArrival,
    };
  }
}