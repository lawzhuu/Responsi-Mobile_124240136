import 'package:flutter/material.dart';

import '../models/character.dart';
import '../views/karakter_detail_view.dart';
import '../views/karakter_view.dart';
import '../views/favorite_spell.dart';
import '../views/login_screen.dart';
import '../views/spells_view.dart';

// Pengaturan rute dan navigasi terpusat pada aplikasi
class AppRoutes {
  static const String login = '/login';
  static const String characters = '/characters';
  static const String characterDetail = '/character-detail';
  static const String spells = '/spells';
  static const String favoriteSpells = '/favorite-spells';

  // Pemetaan nama rute ke builder halaman yang sesuai
  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginView(),
    characters: (context) => const CharacterView(),
    spells: (context) => const SpellsView(),
    favoriteSpells: (context) => const FavoriteSpellsView(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == characterDetail) {
      final character = settings.arguments as Character?;
      if (character != null) {
        return MaterialPageRoute(
          builder: (context) => CharacterDetailView(character: character),
          settings: settings,
        );
      }
    }
    return null;
  }
}
