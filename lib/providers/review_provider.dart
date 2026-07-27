import 'package:flutter/material.dart';
import '../models/review.dart';
import '../models/mock_data.dart';

class ReviewProvider with ChangeNotifier {
  final List<Review> _reviews = List.from(MockData.sampleReviews);

  List<Review> getReviewsForWatch(String watchId) {
    return _reviews.where((r) => r.watchId == watchId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  double getAverageRating(String watchId) {
    final watchReviews = getReviewsForWatch(watchId);
    if (watchReviews.isEmpty) return 5.0;
    final total = watchReviews.fold(0.0, (sum, r) => sum + r.rating);
    return total / watchReviews.length;
  }

  void addReview({
    required String watchId,
    required String userName,
    required String userAvatar,
    required double rating,
    required String comment,
  }) {
    final newReview = Review(
      id: 'rev_${DateTime.now().millisecondsSinceEpoch}',
      watchId: watchId,
      userName: userName,
      userAvatar: userAvatar,
      rating: rating,
      comment: comment,
      date: DateTime.now(),
      helpfulCount: 0,
      isVerifiedPurchase: true,
    );
    _reviews.insert(0, newReview);
    notifyListeners();
  }

  void markHelpful(String reviewId) {
    final index = _reviews.indexWhere((r) => r.id == reviewId);
    if (index >= 0) {
      _reviews[index].helpfulCount++;
      notifyListeners();
    }
  }
}
