import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hawi_poah/models/character.dart';
import 'package:hawi_poah/models/spell.dart';
import 'package:hawi_poah/services/auth_service.dart';
import 'package:hawi_poah/services/favorite_service.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Pengujian Model Karakter
  group('Pengujian Model Karakter', () {
    test('fromJson dan toJson mengurai data karakter dengan benar', () {
      final json = {
        'fullName': 'Harry James Potter',
        'nickname': 'Harry',
        'hogwartsHouse': 'Gryffindor',
        'interpretedBy': 'Daniel Radcliffe',
        'children': ['James Sirius Potter', 'Albus Severus Potter'],
        'image': 'https://example.com/harry.png',
        'birthdate': 'Jul 31, 1980',
        'index': 0,
      };

      final character = Character.fromJson(json);

      expect(character.fullName, 'Harry James Potter');
      expect(character.nickname, 'Harry');
      expect(character.hogwartsHouse, 'Gryffindor');
      expect(character.interpretedBy, 'Daniel Radcliffe');
      expect(character.children.length, 2);
      expect(character.children.first, 'James Sirius Potter');
      expect(character.image, 'https://example.com/harry.png');
      expect(character.birthdate, 'Jul 31, 1980');
      expect(character.index, 0);

      final map = character.toJson();
      expect(map['fullName'], 'Harry James Potter');
      expect(map['index'], 0);
    });

    test('fromJson menangani data kosong atau null secara aman', () {
      final json = <String, dynamic>{};
      final character = Character.fromJson(json);

      expect(character.fullName, 'Karakter Tidak Dikenal');
      expect(character.nickname, '');
      expect(character.hogwartsHouse, 'Unknown');
      expect(character.children, isEmpty);
      expect(character.index, 0);
    });
  });

  // Pengujian Model Spell
  group('Pengujian Model Spell', () {
    test('fromJson dan toMap mempertahankan data spell dengan tepat', () {
      final json = {
        'spell': 'Accio',
        'use': 'Summoning charm',
        'index': 0,
      };

      final spell = Spell.fromJson(json);
      expect(spell.name, 'Accio');
      expect(spell.description, 'Summoning charm');
      expect(spell.index, 0);

      final map = spell.toMap();
      final fromMap = Spell.fromMap(map);
      expect(fromMap.spell, 'Accio');
      expect(fromMap.use, 'Summoning charm');
      expect(fromMap.index, 0);
    });
  });

  // Pengujian Layanan Autentikasi (AuthService)
  group('Pengujian Layanan Autentikasi', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Kredensial admin yang benar berhasil login', () async {
      final auth = AuthService();

      final result = await auth.login('admin', 'admin123');
      expect(result, isTrue);
      expect(await auth.isLoggedIn(), isTrue);
      expect(await auth.getSavedUsername(), 'admin');
    });

    test('Kredensial salah atau selain admin gagal login', () async {
      final auth = AuthService();

      final result1 = await auth.login('potter', 'hogwarts123');
      expect(result1, isFalse);

      final result2 = await auth.login('admin', 'salahpassword');
      expect(result2, isFalse);

      expect(await auth.isLoggedIn(), isFalse);
    });

    test('Logout menghapus sesi login dari SharedPreferences', () async {
      final auth = AuthService();
      await auth.login('admin', 'admin123');
      expect(await auth.isLoggedIn(), isTrue);

      await auth.logout();
      expect(await auth.isLoggedIn(), isFalse);
      expect(await auth.getSavedUsername(), isNull);
    });
  });

  // Pengujian Layanan Favorit Hive (FavoriteService)
  group('Pengujian Layanan Favorit Hive', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('hive_test_');
      Hive.init(tempDir.path);
      await Hive.openBox(FavoriteService.boxName);
    });

    tearDown(() async {
      await Hive.box(FavoriteService.boxName).close();
      await tempDir.delete(recursive: true);
    });

    test('Tambah, toggle, periksa, dan hapus favorit di Hive', () async {
      final favoriteService = FavoriteService();
      const testSpell = Spell(
        index: 42,
        spell: 'Expecto Patronum',
        use: 'Patronus Charm',
      );

      expect(favoriteService.isFavorite(42), isFalse);
      expect(favoriteService.getFavoriteSpells(), isEmpty);

      // Tambah ke favorit
      await favoriteService.addFavorite(testSpell);
      expect(favoriteService.isFavorite(42), isTrue);
      expect(favoriteService.getFavoriteSpells().length, 1);
      expect(favoriteService.getFavoriteSpells().first.name, 'Expecto Patronum');

      // Toggle menghapus dari favorit
      final toggled = await favoriteService.toggleFavorite(testSpell);
      expect(toggled, isFalse);
      expect(favoriteService.isFavorite(42), isFalse);
      expect(favoriteService.getFavoriteSpells(), isEmpty);

      // Toggle menambahkan kembali ke favorit
      final toggledBack = await favoriteService.toggleFavorite(testSpell);
      expect(toggledBack, isTrue);
      expect(favoriteService.isFavorite(42), isTrue);

      // Hapus secara eksplisit
      await favoriteService.removeFavorite(42);
      expect(favoriteService.isFavorite(42), isFalse);
    });
  });
}
