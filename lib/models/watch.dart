class Watch {
  final String id;
  final String title;
  final String brand;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final List<String> imageUrls;
  final String category; // 'Luxury', 'Chronograph', 'Diver', 'Dress', 'Smart'
  final String type; // e.g. Automatic, Quartz, Solar, Mechanical
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
  bool get hasDiscount => originalPrice != null && originalPrice! > price;
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
}
