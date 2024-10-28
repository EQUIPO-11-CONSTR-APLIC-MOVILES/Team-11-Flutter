import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restau/navigation/user_viewmodel.dart';
import 'package:restau/review/review_repository.dart';

class ReviewViewmodel {
  ReviewRepository repo = ReviewRepository();
  UserViewModel user = UserViewModel();

  String checkValidReview(description, rating) {
    if (description == null) {
      return 'null';
    } else if (description.length <= 1){
      return 'length';
    } else if (rating == 0){
      return 'rating';
    }
    return 'valid';
  }

  void registerReview(authorName, authorPFP, description, rating, restaurantId) async {
    final review = {
      "authorId": await user.getUserId(),
      "authorName": authorName,
      "authorPFP": authorPFP,
      "date": FieldValue.serverTimestamp(),
      "description": description,
      "rating": rating,
      "restaurantId": restaurantId
    };
    repo.registerReview(review);

  }
}