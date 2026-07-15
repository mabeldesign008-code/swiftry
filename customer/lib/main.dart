import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/theme/app_theme.dart';
import 'core/config/env.dart';
import 'core/storage/secure_storage_service.dart';
import 'core/storage/local_storage_service.dart';
import 'core/router/app_router.dart';
import 'screens/welcome_screen.dart';
import 'screens/search_screen.dart';
import 'screens/home_screen_v2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env if exists (for local dev) - optional, dart-define is preferred for production
  try {
    await dotenv.load(fileName: ".env");
  } catch (_) {
    // .env not found - using dart-define or defaults
  }

  // Lock to portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Validate env setup in debug
  if (Env.isDevelopment) {
    final warnings = EnvValidator.validate();
    for (final w in warnings) {
      debugPrint('⚠️ ENV WARNING: $w');
    }
  }

  // TODO Backend: Check auth token and decide initial route
  // For now always start at welcome, but structure ready for auto-login
  // final secureStorage = SecureStorageService();
  // final isLoggedIn = await secureStorage.isLoggedIn();
  // final token = await secureStorage.getToken();
  // initialLocation = isLoggedIn && token != null ? '/home' : '/welcome'

  runApp(const ProviderScope(child: SwiftreeApp()));
}

class SwiftreeApp extends ConsumerWidget {
  const SwiftreeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Option 1: Use GoRouter (new, recommended) - uncomment to use
    // final router = ref.watch(appRouterProvider);
    // return MaterialApp.router(
    //   title: 'swiftree',
    //   debugShowCheckedModeBanner: false,
    //   theme: AppTheme.lightTheme,
    //   routerConfig: router,
    // );

    // Option 2: Legacy MaterialApp with named routes (current, backward compatible)
    // Keeping legacy for now to avoid breaking existing MaterialPageRoute pushes
    // TODO Backend: Migrate all screens to GoRouter when auth guard is real
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
