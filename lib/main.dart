import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'services/auth_services.dart';
import 'services/favorite_service.dart';
import 'utils/app_routes.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await Hive.openBox(FavoriteService.boxName);

  final authService = AuthService();
  final bool isLoggedIn = await authService.isLoggedIn();

  runApp(
    HogwartsApp(
      initialRoute: isLoggedIn ? AppRoutes.characters : AppRoutes.login,
    ),
  );
}

class HogwartsApp extends StatelessWidget {
  final String initialRoute;

  const HogwartsApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ' ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.magicalTheme,
      initialRoute: initialRoute,
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
