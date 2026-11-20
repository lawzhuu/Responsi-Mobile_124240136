import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/spells.dart';
import '../services/favorite_service.dart';
import '../utils/app_theme.dart';
import '../widgets/spell_card.dart';

class FavoriteSpellsView extends StatefulWidget {
  const FavoriteSpellsView({super.key});

  @override
  State<FavoriteSpellsView> createState() => _FavoriteSpellsViewState();
}

class _FavoriteSpellsViewState extends State<FavoriteSpellsView> {
  final FavoriteService _favoriteService = FavoriteService();

  // Menghapus spell dari database lokal Hive
  Future<void> _removeFavorite(Spell spell) async {
    await _favoriteService.removeFavorite(spell.index);

    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "Spell '${spell.name}' dihapus dari favorit.",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Spells'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          tooltip: 'Kembali',
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ValueListenableBuilder<Box>(
        valueListenable: _favoriteService.listenable,
        builder: (context, box, _) {
          final favoriteSpells = _favoriteService.getFavoriteSpells();

          // Tampilan ketika daftar favorit masih kosong
          if (favoriteSpells.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.darkSurfaceCard,
                        border: Border.all(
                          color: AppTheme.antiqueGold.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.star_border_rounded,
                        size: 40,
                        color: AppTheme.antiqueGold.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Belum Ada Spell Favorit',
                      style: TextStyle(
                        color: AppTheme.antiqueGold,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Jelajahi library spell Hogwarts dan ketuk ikon bintang untuk menyimpan spell pilihan Anda.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
                child: Row(
                  children: [
                    const Icon(
                      Icons.bookmark_added_rounded,
                      color: AppTheme.antiqueGold,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Spell Tersimpan (${favoriteSpells.length})',
                      style: const TextStyle(
                        color: AppTheme.antiqueGold,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: favoriteSpells.length,
                  itemBuilder: (context, index) {
                    final spell = favoriteSpells[index];
                    return SpellCard(
                      spell: spell,
                      isFavorite: true,
                      isDeleteMode: true,
                      onFavoriteToggle: () => _removeFavorite(spell),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
