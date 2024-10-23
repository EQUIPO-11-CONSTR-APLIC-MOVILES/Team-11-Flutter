import 'package:flutter/material.dart';

class StarRatingController extends ValueNotifier<int> {
  StarRatingController([int rating = 0]) : super(rating);

  int get rating => value;
  set rating(int newRating) {
    value = newRating;
  }
}