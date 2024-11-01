import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:restau/models/restaurant.dart';

class SchedulePopup extends StatelessWidget {
  final Restaurant restaurant;

  const SchedulePopup({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    // Get the current day and time
    DateTime now = DateTime.now();
    String currentDay = DateFormat('EEEE').format(now).toLowerCase();
    DateFormat inputFormat = DateFormat('HH:mm');
    DateFormat outputFormat = DateFormat('h:mm a');

    // Extract the current time as TimeOfDay
    TimeOfDay currentTime = TimeOfDay(hour: now.hour, minute: now.minute);

    // Check if the current time is within the schedule for the current day
    bool isOpen = false;
    if (restaurant.schedule.containsKey(currentDay)) {
      String startString =
          restaurant.schedule[currentDay]!['start'].toString().padLeft(4, '0');
      String endString =
          restaurant.schedule[currentDay]!['end'].toString().padLeft(4, '0');

      // Insert colon in the middle
      startString =
          "${startString.substring(0, 2)}:${startString.substring(2)}";
      endString = "${endString.substring(0, 2)}:${endString.substring(2)}";

      DateTime startTime = inputFormat.parse(startString);
      DateTime endTime = inputFormat.parse(endString);

      // Extract the start and end times as TimeOfDay
      TimeOfDay startOfDay =
          TimeOfDay(hour: startTime.hour, minute: startTime.minute);
      TimeOfDay endOfDay =
          TimeOfDay(hour: endTime.hour, minute: endTime.minute);

      // Compare the current time with the start and end times
      if (_isTimeOfDayInRange(currentTime, startOfDay, endOfDay)) {
        isOpen = true;
      }
    }

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isOpen ? 'Open' : 'Closed',
            style: GoogleFonts.poppins(
              color: isOpen ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: restaurant.schedule.entries.map((entry) {
              String day = entry.key[0].toUpperCase() + entry.key.substring(1);

              // Convert int to string
              String startString =
                  entry.value['start'].toString().padLeft(4, '0');
              String endString = entry.value['end'].toString().padLeft(4, '0');

              // Insert colon in the middle
              startString =
                  "${startString.substring(0, 2)}:${startString.substring(2)}";
              endString =
                  "${endString.substring(0, 2)}:${endString.substring(2)}";

              // Parse the time strings
              DateTime startTime = inputFormat.parse(startString);
              DateTime endTime = inputFormat.parse(endString);

              // Format the times to 12-hour format
              String formattedStart = outputFormat.format(startTime);
              String formattedEnd = outputFormat.format(endTime);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      day,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 16.0), // Space between day and hours
                    Text(
                      '$formattedStart - $formattedEnd',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  bool _isTimeOfDayInRange(
      TimeOfDay currentTime, TimeOfDay startTime, TimeOfDay endTime) {
    final currentMinutes = currentTime.hour * 60 + currentTime.minute;
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;

    return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
  }
}
