import 'package:flutter/material.dart';

import '../models/spells.dart';
import '../utils/app_theme.dart';

// card deskripsi spell magic
class SpellCard extends StatelessWidget {
  final Spell spell;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final bool isDeleteMode;

  const SpellCard({
    super.key,
    required this.spell,
    required this.isFavorite,
    required this.onFavoriteToggle,
    this.isDeleteMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ikon Magic Wand & Nomor urut spell
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isFavorite
                      ? [AppTheme.antiqueGold, AppTheme.goldDark]
                      : [AppTheme.darkSurface, AppTheme.darkSurfaceCard],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: isFavorite
                      ? AppTheme.antiqueGold
                      : AppTheme.antiqueGold.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.auto_fix_high,
                  size: 22,
                  color: isFavorite
                      ? const Color(0xFF161F2E)
                      : AppTheme.antiqueGold,
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Nama & fungsi spell
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          spell.name,
                          style: const TextStyle(
                            color: AppTheme.antiqueGold,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.darkSurface,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppTheme.antiqueGold.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          '#${spell.index}',
                          style: TextStyle(
                            color: AppTheme.textMuted.withValues(alpha: 0.7),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    spell.description,
                    style: const TextStyle(
                      color: AppTheme.textLight,
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Tombol simpan & hapus favorit
            IconButton(
              onPressed: onFavoriteToggle,
              icon: Icon(
                isDeleteMode
                    ? Icons.delete_outline_rounded
                    : (isFavorite
                          ? Icons.star_rounded
                          : Icons.star_border_rounded),
                color: isDeleteMode
                    ? const Color(0xFFEF4444)
                    : (isFavorite ? AppTheme.antiqueGold : AppTheme.textMuted),
                size: 26,
              ),
              tooltip: isDeleteMode
                  ? 'Hapus dari favorit'
                  : (isFavorite
                        ? 'Hapus dari favorit'
                        : 'Tambahkan ke favorit'),
            ),
          ],
        ),
      ),
    );
  }
}
