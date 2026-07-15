import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'screens/welcome_screen.dart';
import 'screens/search_screen.dart';
import 'screens/home_screen_v2.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Lock to portrait orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Status bar style — light icons on the blue app bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const ProviderScope(child: swiftreeApp()));
}

class swiftreeApp extends StatelessWidget {
  const swiftreeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'swiftree',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const WelcomeScreen(),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/home': (context) => const HomeScreenV2(),
        '/search': (context) => const SearchScreen(),
      },
    );
  }
}
