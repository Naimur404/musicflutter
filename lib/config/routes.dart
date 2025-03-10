import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/player_screen.dart';
import 'package:flutter_application_1/screens/search_screen.dart';
import 'package:flutter_application_1/screens/library_screen.dart';
import 'package:flutter_application_1/screens/settings_screen.dart';
import 'package:flutter_application_1/screens/splash_screen.dart';

// Define routes for the app
final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const SplashScreen(),
  '/home': (context) => const HomeScreen(),
  '/player': (context) => const PlayerScreen(),
  '/search': (context) => const SearchScreen(),
  '/library': (context) => const LibraryScreen(),
  '/settings': (context) => const SettingsScreen(),
};

// Route generator for handling dynamic routes with parameters
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => const SplashScreen());
    case '/home':
      return MaterialPageRoute(builder: (context) => const HomeScreen());
    case '/player':
      return MaterialPageRoute(builder: (context) => const PlayerScreen());
    case '/search':
      return MaterialPageRoute(builder: (context) => const SearchScreen());
    case '/library':
      return MaterialPageRoute(builder: (context) => const LibraryScreen());
    case '/settings':
      return MaterialPageRoute(builder: (context) => const SettingsScreen());
    default:
      // If the route is not found, show error page
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
          ),
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }
}