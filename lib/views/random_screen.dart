import 'package:flutter/material.dart';
import 'package:restau/navigation/user_viewmodel.dart';
import 'package:restau/review/write_review_screen.dart';

class RandomScreen extends StatefulWidget {
  const RandomScreen({super.key});

  @override
  State<RandomScreen> createState() => _RandomScreenState();
}

class _RandomScreenState extends State<RandomScreen> {
  UserViewModel vm = UserViewModel();
  String? restaurants;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
