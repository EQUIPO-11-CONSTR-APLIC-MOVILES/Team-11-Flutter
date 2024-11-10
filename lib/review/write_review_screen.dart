import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:restau/navigation/user_viewmodel.dart';
import 'package:restau/review/review_viewmodel.dart';
import 'package:restau/widgets/rating_stars.dart';
import 'package:restau/widgets/star_rating_controller.dart';
import 'package:restau/random/random_repository.dart';

class WriteReviewScreen extends StatefulWidget {
  WriteReviewScreen({super.key, required this.restaurant, this.initialRating = 0, this.randomReviewDocumentId = ""});

  final String restaurant;
  final int initialRating;
  final String randomReviewDocumentId;

  final RandomRepository randomRepository = RandomRepository();

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  double elementSpacing = 15;
  late final StarRatingController starController;
  final UserViewModel user = UserViewModel();
  final ReviewViewmodel vm = ReviewViewmodel();
  final TextEditingController reviewController = TextEditingController();
  final ValueNotifier<String?> _errorMessage = ValueNotifier(null);
  StreamSubscription? connectivitySubscription;
  bool isOffline = false;
  bool _dataLoaded = false; 

  @override
  void initState() {
    super.initState();
    starController = StarRatingController(widget.initialRating);
    // Check connectivity status initially and listen for changes
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((status) {
      setState(() {
        isOffline = status == ConnectivityResult.none;
      });
    });
  }

  @override
  void dispose() {
    connectivitySubscription?.cancel();
    reviewController.dispose();
    _errorMessage.dispose();
    super.dispose();
  }

  void sendReview() async {
    String res = vm.checkValidReview(reviewController.text, starController.rating);
    if (res == 'valid') {
      final userName = await user.getUserName();
      final userPic = await user.getUserPic();

      if (isOffline) {
        // Show offline message in a dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("No Internet Connection"),
              content: const Text(
                "You have no internet connection, but your review will be saved and posted once you regain connection.",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Send review (handles offline saving in ViewModel)
                    vm.registerReview(userName, userPic, reviewController.text.trim(), starController.rating, widget.restaurant);
                    widget.randomRepository.updateRandomReview(widget.randomReviewDocumentId);
                    Navigator.pop(context); // Close the dialog first
                    navigateBack(); // Then navigate back
                  },
                  child: const Text(
                    'Ok',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        // Send review (handles offline saving in ViewModel)
        vm.registerReview(userName, userPic, reviewController.text.trim(), starController.rating, widget.restaurant);
        widget.randomRepository.updateRandomReview(widget.randomReviewDocumentId);
        navigateBack();
      }
      
    } else if (res == 'length') {
      _errorMessage.value = "Please add a review before sending";
    } else if (res == 'rating') {
      _errorMessage.value = "Please add a star rating before sending";
    }
  }

  void navigateBack() {
    starController.rating = 0;
    reviewController.text = "";
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write review'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: Future.wait([user.getUserPic(), user.getUserName()]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && !_dataLoaded) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError && !_dataLoaded && isOffline) {
            // Show a message if there's no internet and data hasn't loaded before
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    "Connect to the internet to write a review",
                    style: TextStyle(fontFamily: 'Poppins', color: Colors.grey, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            _dataLoaded = true; // Data loaded successfully

            final userPic = snapshot.data?[0];
            final userName = snapshot.data?[1];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        userName ?? 'User',
                        style: const TextStyle(fontSize: 18, fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: userPic != null ? NetworkImage(userPic) : null,
                        radius: 25,
                      ),
                      const Spacer(),
                      RatingStars(controller: starController),
                    ],
                  ),
                  SizedBox(height: elementSpacing),
                  TextField(
                    controller: reviewController,
                    maxLength:100000,
                    maxLines: 15,
                    minLines: 2,
                    decoration: const InputDecoration(
                      hintText: 'Share details of your own experience here',
                      hintStyle: TextStyle(fontFamily: "Poppins", color: Colors.grey),
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      counterText: "",
                    ),
                  ),
                  ValueListenableBuilder<String?>(
                    valueListenable: _errorMessage,
                    builder: (context, error, child) {
                      if (error == null) return const SizedBox.shrink();
                      return Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.info_outline, color: Colors.red),
                            Text(
                              error,
                              style: const TextStyle(
                                color: Colors.red,
                                fontFamily: 'Poppins',
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: elementSpacing),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: sendReview,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(const Color(0xFFD9534F)),
                      ),
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            );
          }

          // Return an empty container if none of the above conditions are met
          return const SizedBox.shrink();
        },
      ),
    );
  }
}