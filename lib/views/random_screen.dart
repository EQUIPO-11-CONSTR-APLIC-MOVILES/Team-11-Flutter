import 'package:flutter/material.dart';

class RandomScreen extends StatelessWidget {
  const RandomScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RandomScreen'),
      ),
      body: const Center(
        child: Text('RandomScreen'),
      ),
    );
  }
}