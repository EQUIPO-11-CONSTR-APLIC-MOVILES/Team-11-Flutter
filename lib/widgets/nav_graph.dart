import 'package:flutter/material.dart';
import '../views/home_screen.dart';

class NavGraph extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const NavGraph({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (BuildContext _) => const HomeScreen();
            break;
          // Add other routes here
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}