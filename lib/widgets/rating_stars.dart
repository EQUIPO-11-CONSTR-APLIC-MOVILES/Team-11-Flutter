import 'package:flutter/material.dart';
import 'package:restau/widgets/star_rating_controller.dart';

class RatingStars extends StatefulWidget {
  final bool fixed; // If true, stars are not interactive
  final double size;
  final bool grey; // Size of the stars
  final StarRatingController? controller; // Optional controller to manage the rating

  const RatingStars({
    super.key,
    this.fixed = false, // Default: not fixed, stars can be pressed
    this.size = 50.0, 
    this.grey = false, // Default star size
    this.controller, // Controller is optional
  });

  @override
  State<RatingStars> createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {
  late StarRatingController _controller; // Internal controller

  @override
  void initState() {
    super.initState();
    // Use the provided controller or create an internal one
    _controller = widget.controller ?? StarRatingController();
    _controller.addListener(_updateRating); // Listen to changes in the controller
  }

  @override
  void dispose() {
    _controller.removeListener(_updateRating); // Clean up listener
    if (widget.controller == null) {
      _controller.dispose(); // Only dispose the internal controller if it was created here
    }
    super.dispose();
  }

  void _updateRating() {
    setState(() {}); // Redraw when the controller changes the rating
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Keeps the row size to its contents
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: widget.fixed
              ? null // If fixed is true, the stars are non-interactive
              : () {
                  setState(() {
                    _controller.rating = index + 1; // Update the controller's rating
                  });
                },
          child: Container(
            padding: const EdgeInsets.all(1), // Reduces the clickable area
            child: Icon(
              index < _controller.rating
                  ? Icons.star_rounded
                  : Icons.star_border_rounded, // Filled or empty star
              color: widget.grey ? const Color(0xFFB9B9B9) : const Color(0xFFFFEEAD), // Star color
              size: widget.size, // Use the passed-in star size
            ),
          ),
        );
      }),
    );
  }
}