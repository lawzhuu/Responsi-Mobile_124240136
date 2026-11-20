import 'package:flutter/material.dart';

import '../models/character.dart';
import '../services/api_services.dart';
import '../services/auth_services.dart';
import '../utils/app_routes.dart';
import '../utils/app_theme.dart';
import '../widgets/character_card.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';

class CharacterView extends StatefulWidget {
  const CharacterView({super.key});

  @override
  State<CharacterView> createState() => _CharacterViewState();
}

class _CharacterViewState extends State<CharacterView> {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();

  late Future<List<Character>> _charactersFuture;

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  // Mengambil data karakter dari API
  void _loadCharacters() {
    setState(() {
      _charactersFuture = _apiService.fetchCharacters();
    });
  }

  // proses logout dari aplikasi/sistem
  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkSurfaceCard,
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: AppTheme.antiqueGold),
            SizedBox(width: 10),
            Text(
              'Keluar dari Sistem?',
              style: TextStyle(
                color: AppTheme.antiqueGold,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          'Apakah Anda yakin ingin mengakhiri sesi dan keluar?',
          style: TextStyle(color: AppTheme.textLight),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Batal',
              style: TextStyle(color: AppTheme.textMuted),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.burgundy,
              foregroundColor: Colors.white,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      await _authService.logout();
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_outline, color: AppTheme.antiqueGold),
              SizedBox(width: 10),
              Text(
                'Berhasil keluar dari aplikasi.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          backgroundColor: AppTheme.darkSurfaceCard,
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Karakter Hogwarts'),
        actions: [
          // Tombol Navigasi ke Halaman Spells
          IconButton(
            icon: const Icon(Icons.auto_fix_high_rounded),
            tooltip: 'Lihat Spells',
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.spells);
            },
          ),
          // Tombol Logout
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Keluar',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: FutureBuilder<List<Character>>(
        future: _charactersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MagicalLoadingWidget(
              message: 'Memuat data karakter dari arsip magic...',
            );
          }

          if (snapshot.hasError) {
            final error = snapshot.error;
            final message = error != null
                ? error.toString().replaceAll('Exception:', '').trim()
                : 'Gagal memuat data karakter Hogwarts.';

            return MagicalErrorWidget(
              message: message,
              onRetry: _loadCharacters,
            );
          }

          final characters = snapshot.data;
          if (characters == null || characters.isEmpty) {
            return const Center(
              child: Text(
                'Karakter Tidak Ditemukan.',
                style: TextStyle(color: AppTheme.textMuted),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.68,
            ),
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final character = characters[index];
              return CharacterCard(
                character: character,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.characterDetail,
                    arguments: character,
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: AppTheme.darkSurface,
        selectedItemColor: AppTheme.antiqueGold,
        unselectedItemColor: AppTheme.textMuted,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_rounded),
            label: 'Characters',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_fix_high_rounded),
            label: 'Spells',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_rounded),
            label: 'Favorites',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacementNamed(context, AppRoutes.spells);
          } else if (index == 2) {
            Navigator.pushNamed(context, AppRoutes.favoriteSpells);
          }
        },
      ),
    );
  }
}
