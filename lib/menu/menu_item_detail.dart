import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:restau/models/menu_item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuItemDetail extends StatelessWidget {
  final MenuItem menuItem;
  final String restaurantName;

  const MenuItemDetail({super.key, required this.menuItem, required this.restaurantName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center the content horizontally
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SvgPicture.asset(
                'lib/assets/drawable/menu_icon.svg',
                width: 25,
                height: 25,
                color: const Color(0xFF2F2F2F),
              ),
              Text(
                " $restaurantName Menu",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: const Color(0xFF2F2F2F),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],),
            const SizedBox(height: 16.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: CachedNetworkImage(
                imageUrl: menuItem.imageUrl,
                fit: BoxFit.fill,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error,
                      size: 50,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Unable to load image (connect to internet)',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              )
            ),
            const SizedBox(height: 16.0),
            // Title of the menu item with bold styling
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 65,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        menuItem.name,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                Flexible(
                  flex: 35,
                  child: Text(
                    '\$ ${menuItem.price}',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // Display the description text
            Text(
              menuItem.description,
              textAlign: TextAlign.justify,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey,
                height: 1.5, // Adjust line height
              ),
            ),
          ],
        ),
      ),
    );
  }
}