import 'package:flutter/material.dart';

class ButtonRow extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onButtonPressed;

  const ButtonRow({
    super.key,
    required this.selectedIndex,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // "All" Button
        ElevatedButton(
          onPressed: () => onButtonPressed(0),
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedIndex == 0
                ? const Color(0xFFD9534F)
                : Colors.grey.shade200, // Red if selected
            foregroundColor: selectedIndex == 0 ? Colors.white : Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: const Text("All"),
        ),
        // "Open Now" Button
        ElevatedButton(
          onPressed: () => onButtonPressed(1),
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedIndex == 1
                ? const Color(0xFFD9534F)
                : Colors.grey.shade200,
            foregroundColor: selectedIndex == 1 ? Colors.white : Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: const Text("Open Now"),
        ),
        // "For You" Button
        ElevatedButton(
          onPressed: () => onButtonPressed(2),
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedIndex == 2
                ? const Color(0xFFD9534F)
                : Colors.grey.shade200,
            foregroundColor: selectedIndex == 2 ? Colors.white : Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: const Text("For You"),
        ),
      ],
    );
  }
}
