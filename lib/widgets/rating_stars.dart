import 'package:flutter/material.dart';

class RatingStars extends StatefulWidget {
  final bool fixed; // If true, stars are not interactive
  final int rating; // Initial rating (1 to 5)
  final double size; // Size of the stars

  const RatingStars({
    super.key,
    this.fixed = false, // Default: not fixed, stars can be pressed
    this.rating = 0, // Default: no stars filled
    this.size = 45.0, // Default star size
  });

  @override
  State<RatingStars> createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {
  late int _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.rating; // Set the initial rating based on widget's parameter
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Keeps the row size to its contents
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: widget.fixed
              ? null // If fixed is true, the stars are non-interactive
              : () {
                  setState(() {
                    _rating = index + 1; // Update the rating on press
                  });
                },
          icon: Icon(
            index < _rating ? Icons.star_rounded : Icons.star_border_rounded, // Filled or empty star
            color: const Color(0xFFFFEEAD), // Star color
            size: widget.size, // Use the passed-in star size
          ),
        );
      }),
    );
  }
}
