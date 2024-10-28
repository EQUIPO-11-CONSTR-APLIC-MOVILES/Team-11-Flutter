import 'package:flutter/material.dart';
import 'package:restau/navigation/user_viewmodel.dart';
import 'package:restau/review/review_viewmodel.dart';
import 'package:restau/widgets/rating_stars.dart';
import 'package:restau/widgets/star_rating_controller.dart';

class WriteReviewScreen extends StatefulWidget {
  const WriteReviewScreen({super.key, required this.restaurant});

  final String restaurant;

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  double elementSpacing = 15;

  final starController = StarRatingController();

  UserViewModel user = UserViewModel();
  ReviewViewmodel vm = ReviewViewmodel();

  TextEditingController reviewController = TextEditingController();

  void sendReview() async {
    if (vm.checkValidReview(reviewController.text, starController.rating) == 'valid'){
      vm.registerReview(
        await user.getUserName(), 
        await user.getUserPic(), 
        reviewController.text, 
        starController.rating, 
        widget.restaurant
      );
    }
    navigateBack();
  }

  void navigateBack(){
    //TODO: volver al detalle cuando se haya escrito el review
    starController.rating = 0;
    reviewController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([user.getUserPic(), user.getUserName()]), // Get both user pic and name
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading user info'));
        } else {
          final userPic = snapshot.data?[0]; // Picture URL
          final userName = snapshot.data?[1]; // Username

          return Padding(
            padding: const EdgeInsets.only(left:32.0, right: 32.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      userName ?? 'User', // Fallback if no name
                      style: const TextStyle(fontSize: 18, fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: userPic != null
                          ? NetworkImage(userPic)
                          : null, // Fallback if no pic
                      radius: 25, // Size of the avatar
                    ),
                    const Spacer(),
                    RatingStars(controller: starController), 
                  ],
                ),
                SizedBox(height: elementSpacing),
                TextField(
                  controller: reviewController,
                  maxLines: 13,
                  minLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Share details of your own experience here',
                    hintStyle: TextStyle(fontFamily: "Poppins", color: Colors.grey),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
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
      },
    );
  }
}
