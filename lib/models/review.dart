class Review {
  final String id;
  final String watchId;
  final String userName;
  final String userAvatar;
  final double rating;
  final String comment;
  final DateTime date;
  int helpfulCount;
  bool isVerifiedPurchase;
  List<String> images;

  Review({
    required this.id,
    required this.watchId,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    required this.date,
    this.helpfulCount = 0,
    this.isVerifiedPurchase = true,
    this.images = const [],
  });
}
