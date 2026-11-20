import 'package:flutter/material.dart';
import '../services/auth_services.dart';
import '../utils/app_routes.dart';
import '../utils/app_theme.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: FutureBuilder<String?>(
        future: authService.getSavedUsername(),
        builder: (context, snapshot) {
          final username = snapshot.data ?? '-';
          final initial = username.isNotEmpty && username != '-'
              ? username[0].toUpperCase()
              : '?';

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: AppTheme.burgundy,
                    child: Text(
                      initial,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.antiqueGold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  username,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 36),
                ElevatedButton.icon(
                  onPressed: () async {
                    await authService.logout();
                    if (!context.mounted) return;
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Logout'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}