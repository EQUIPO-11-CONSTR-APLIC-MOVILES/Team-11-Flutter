import 'package:flutter/material.dart';

class PreferenceButton extends StatefulWidget {
  const PreferenceButton({super.key, required this.option, required this.selectedPreferences});

  final String option;
  final Set<String> selectedPreferences;

  @override
  _PreferenceButtonState createState() => _PreferenceButtonState();
}

class _PreferenceButtonState extends State<PreferenceButton> {
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    isSelected = widget.selectedPreferences.contains(widget.option);
  }

  void toggleSelection() {
    setState(() {
      isSelected = !isSelected;
      if (isSelected) {
        widget.selectedPreferences.add(widget.option);
      } else {
        widget.selectedPreferences.remove(widget.option);
      }
      print(widget.selectedPreferences);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(isSelected ? const Color(0xFFFFEEAD) : Colors.white),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        elevation: WidgetStateProperty.all(5.0),
      ),
      onPressed: toggleSelection,
      child: Text(
        widget.option,
        style: const TextStyle(
          color: Colors.black,
          fontFamily: 'Poppins',
          fontSize: 16.0,
        ),
      ),
    );
  }
}