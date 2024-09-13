import 'package:flutter/material.dart';

class LikedScreen extends StatelessWidget {
  const LikedScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LikedScreen'),
      ),
      body: const Center(
        child: Text('LikedScreen'),
      ),
    );
  }
}