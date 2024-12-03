import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restau/models/restaurant.dart';
import 'package:restau/review/review_list.dart';
import 'package:restau/widgets/schedule_popup.dart';
import 'package:restau/menu/menu_screen.dart'; // Import the MenuScreen

class IconsRow extends StatelessWidget {
  final Restaurant restaurant;
  final String randomReviewDocumentId;

  const IconsRow(
      {super.key, required this.restaurant, this.randomReviewDocumentId = ""});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MenuScreen(
                  restaurantID: restaurant.getId(), restaurantName: restaurant.getName(),), // Pass the restaurant name
              ),
            );
          },
          child: _buildIconWithName(Icons.fastfood, 'Menu'),
        ),
        GestureDetector(
          onTap: () {
            _showSchedulePopup(context, restaurant);
          },
          child: _buildIconWithName(Icons.calendar_month, 'Schedule'),
        ),
        _buildIconWithName(Icons.call, 'Contact'),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReviewListScreen(
                    restaurantID: restaurant.getId(),
                    randomReviewDocumentId: randomReviewDocumentId),
              ),
            );
          },
          child: _buildIconWithName(Icons.star, 'Rate'),
        ),
      ],
    );
  }

  Widget _buildIconWithName(IconData icon, String name) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.black,
          size: 32,
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showSchedulePopup(BuildContext context, Restaurant restaurant) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SchedulePopup(restaurant: restaurant);
      },
    );
  }
}
