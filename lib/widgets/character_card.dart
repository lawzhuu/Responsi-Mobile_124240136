import 'package:flutter/material.dart';

import '../models/character.dart';
import '../utils/app_theme.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final VoidCallback onTap;

  const CharacterCard({
    super.key,
    required this.character,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final houseColor = AppTheme.getHouseColor(character.hogwartsHouse);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: AppTheme.antiqueGold.withValues(alpha: 0.15),
        highlightColor: AppTheme.antiqueGold.withValues(alpha: 0.08),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gambar karakter & banner house nya
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: const Color(0xFF0F172A),
                    child: character.image.isNotEmpty
                        ? Image.network(
                            character.image,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    value: progress.expectedTotalBytes != null
                                        ? progress.cumulativeBytesLoaded /
                                              (progress.expectedTotalBytes ?? 1)
                                        : null,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          AppTheme.antiqueGold,
                                        ),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(
                                  Icons.person,
                                  size: 48,
                                  color: AppTheme.antiqueGold.withValues(
                                    alpha: 0.4,
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Icon(
                              Icons.person,
                              size: 48,
                              color: AppTheme.antiqueGold.withValues(
                                alpha: 0.4,
                              ),
                            ),
                          ),
                  ),

                  // Gradien warna dibagian bawah foto
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppTheme.darkSurfaceCard,
                            AppTheme.darkSurfaceCard.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Label nama house nya di kanan atas tiap card
                  if (character.hogwartsHouse.isNotEmpty &&
                      character.hogwartsHouse.toLowerCase() != 'unknown')
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: houseColor.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppTheme.antiqueGold.withValues(alpha: 0.6),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          character.hogwartsHouse,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Deskripsi singkat tiap karakter
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    character.fullName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppTheme.textLight,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    character.interpretedBy.isNotEmpty
                        ? 'Pemeran: ${character.interpretedBy}'
                        : (character.nickname.isNotEmpty
                              ? 'Panggilan: "${character.nickname}"'
                              : 'Karakter Hogwarts'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppTheme.textMuted.withValues(alpha: 0.85),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
