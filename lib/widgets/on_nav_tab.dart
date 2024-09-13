import 'package:flutter/material.dart';

void onNavTab(GlobalKey<NavigatorState> navigatorKey, String route) {
  navigatorKey.currentState?.pushNamedAndRemoveUntil(
    route,
    (Route<dynamic> route) => false,
  );
}