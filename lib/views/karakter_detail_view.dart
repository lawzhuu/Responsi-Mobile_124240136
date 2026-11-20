import 'package:flutter/material.dart';

import '../models/character.dart';
import '../utils/app_theme.dart';

class CharacterDetailView extends StatelessWidget {
  final Character character;

  const CharacterDetailView({super.key, required this.character});

  // ambil warna sesuai house tiap karakter
  @override
  Widget build(BuildContext context) {
    final houseColor = AppTheme.getHouseColor(character.hogwartsHouse);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          character.nickname.isNotEmpty
              ? character.nickname
              : character.fullName,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          tooltip: 'Kembali',
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Foto Karakter dengan garis tepi sesuai dengan house nya
            Center(
              child: Container(
                width: 200,
                height: 260,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: houseColor != AppTheme.antiqueGold
                        ? houseColor
                        : AppTheme.antiqueGold,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: houseColor.withValues(alpha: 0.35),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(17),
                  child: character.image.isNotEmpty
                      ? Image.network(
                          character.image,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: progress.expectedTotalBytes != null
                                    ? progress.cumulativeBytesLoaded /
                                          (progress.expectedTotalBytes ?? 1)
                                    : null,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppTheme.antiqueGold,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppTheme.darkSurfaceCard,
                              child: const Center(
                                child: Icon(
                                  Icons.person,
                                  size: 80,
                                  color: AppTheme.antiqueGold,
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: AppTheme.darkSurfaceCard,
                          child: const Center(
                            child: Icon(
                              Icons.person,
                              size: 80,
                              color: AppTheme.antiqueGold,
                            ),
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Nama Lengkap Karakter & Badge House
            Center(
              child: Column(
                children: [
                  Text(
                    character.fullName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTheme.antiqueGold,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: houseColor.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.antiqueGold.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      character.hogwartsHouse.isNotEmpty &&
                              character.hogwartsHouse.toLowerCase() != 'unknown'
                          ? 'House ${character.hogwartsHouse}'
                          : 'House Unknown',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Judul bagian rincian
            const Row(
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  color: AppTheme.antiqueGold,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Profil & Informasi Karakter',
                  style: TextStyle(
                    color: AppTheme.antiqueGold,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(color: AppTheme.antiqueGold, thickness: 0.5),
            const SizedBox(height: 10),

            // Menampilkan seluruh deskripsi karakter
            _buildInfoTile(
              icon: Icons.badge_rounded,
              title: 'Nama Lengkap',
              value: character.fullName,
            ),
            _buildInfoTile(
              icon: Icons.tag_rounded,
              title: 'Nama Panggilan',
              value: character.nickname.isNotEmpty
                  ? character.nickname
                  : 'Tidak ada',
            ),
            _buildInfoTile(
              icon: Icons.shield_rounded,
              title: 'Hogwarts House',
              value: character.hogwartsHouse.isNotEmpty
                  ? character.hogwartsHouse
                  : 'Tidak ditentukan',
              accentColor: houseColor,
            ),
            _buildInfoTile(
              icon: Icons.movie_creation_rounded,
              title: 'Pemeran / Aktor',
              value: character.interpretedBy.isNotEmpty
                  ? character.interpretedBy
                  : 'Tidak tercatat dalam daftar film',
            ),
            _buildInfoTile(
              icon: Icons.cake_rounded,
              title: 'Tanggal Lahir',
              value: character.birthdate.isNotEmpty
                  ? character.birthdate
                  : 'Tanggal tidak diketahui',
            ),
            _buildInfoTile(
              icon: Icons.format_list_numbered_rounded,
              title: 'Indeks Arsip',
              value: '#${character.index}',
            ),

            // Card Daftar Anak/Keturunan
            _buildChildrenCard(character.children),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Widget pembantu untuk menampilkan baris informasi
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    Color? accentColor,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (accentColor ?? AppTheme.antiqueGold).withValues(
                  alpha: 0.15,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: accentColor ?? AppTheme.antiqueGold,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      color: AppTheme.textLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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

  // Widget pembantu untuk menampilkan daftar anak
  Widget _buildChildrenCard(List<String> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.antiqueGold.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.family_restroom_rounded,
                    color: AppTheme.antiqueGold,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                const Text(
                  'Anak / Keturunan',
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (children.isEmpty)
              const Padding(
                padding: EdgeInsets.only(left: 42),
                child: Text(
                  'Tidak ada anak yang tercatat dalam arsip',
                  style: TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(left: 42),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: children
                      .map(
                        (child) => Chip(
                          backgroundColor: AppTheme.darkSurface,
                          side: BorderSide(
                            color: AppTheme.antiqueGold.withValues(alpha: 0.3),
                          ),
                          avatar: const Icon(
                            Icons.child_care_rounded,
                            size: 16,
                            color: AppTheme.antiqueGold,
                          ),
                          label: Text(
                            child,
                            style: const TextStyle(
                              color: AppTheme.textLight,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
