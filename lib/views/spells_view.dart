import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/spells.dart';
import '../services/api_services.dart';
import '../services/auth_services.dart';
import '../services/favorite_service.dart';
import '../utils/app_routes.dart';
import '../utils/app_theme.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/spell_card.dart';

class SpellsView extends StatefulWidget {
  const SpellsView({super.key});

  @override
  State<SpellsView> createState() => _SpellsViewState();
}

class _SpellsViewState extends State<SpellsView> {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();
  final FavoriteService _favoriteService = FavoriteService();

  late Future<List<Spell>> _spellsFuture;

  @override
  void initState() {
    super.initState();
    _loadSpells();
  }

  // Ambil daftar spell dari API
  void _loadSpells() {
    setState(() {
      _spellsFuture = _apiService.fetchSpells();
    });
  }

  // Menambahkan atau menghapus spell dari favorit
  Future<void> _toggleFavorite(Spell spell) async {
    final isNowFavorite = await _favoriteService.toggleFavorite(spell);

    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isNowFavorite ? Icons.star_rounded : Icons.star_border_rounded,
              color: AppTheme.antiqueGold,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isNowFavorite
                    ? "Spell '${spell.name}' berhasil ditambahkan ke favorit! ✨"
                    : "Spell '${spell.name}' dihapus dari favorit.",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.darkSurfaceCard,
        duration: const Duration(seconds: 2),
      ),
    );
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
              'Keluar dari Hogwarts?',
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
        title: const Text('Hogwarts Spells'),
        actions: [
          // Tombol Navigasi ke Halaman Favorite Spells
          IconButton(
            icon: const Icon(Icons.star_rounded),
            tooltip: 'Favorite Spells',
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.favoriteSpells);
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
      body: FutureBuilder<List<Spell>>(
        future: _spellsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MagicalLoadingWidget(
              message: 'Mengambil data spell dari Standard Book of Spells...',
            );
          }

          if (snapshot.hasError) {
            final error = snapshot.error;
            final message = error != null
                ? error.toString().replaceAll('Exception:', '').trim()
                : 'Gagal memuat data spell dari arsip magic.';

            return MagicalErrorWidget(message: message, onRetry: _loadSpells);
          }

          final spells = snapshot.data;
          if (spells == null || spells.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada spell yang ditemukan dalam arsip.',
                style: TextStyle(color: AppTheme.textMuted),
              ),
            );
          }

          // Listener reaktif pada card spell secara real time
          return ValueListenableBuilder<Box>(
            valueListenable: _favoriteService.listenable,
            builder: (context, box, _) {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: spells.length,
                itemBuilder: (context, index) {
                  final spell = spells[index];
                  final isFav = _favoriteService.isFavorite(spell.index);

                  return SpellCard(
                    spell: spell,
                    isFavorite: isFav,
                    onFavoriteToggle: () => _toggleFavorite(spell),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
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
          if (index == 0) {
            Navigator.pushReplacementNamed(context, AppRoutes.characters);
          } else if (index == 2) {
            Navigator.pushNamed(context, AppRoutes.favoriteSpells);
          }
        },
      ),
    );
  }
}
