import 'package:flutter/material.dart';
import 'nav_graph.dart';

class NavigatorContent extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const NavigatorContent({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NavGraph(navigatorKey: navigatorKey),
    );
  }
}