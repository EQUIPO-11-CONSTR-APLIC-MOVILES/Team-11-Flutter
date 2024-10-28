import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TagSection extends StatelessWidget {
  final List<String> tags;

  // Constructor to accept the tags list
  const TagSection({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.start,
          spacing: 8.0, // Spacing between tags
          runSpacing: 4.0, // Spacing between lines of tags
          children: tags
              .map((tag) => Chip(
                    label: Text(
                      tag,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: const BorderSide(color: Colors.white),
                    ),
                    elevation: 4.0,
                    shadowColor: Colors.black.withOpacity(0.5),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
