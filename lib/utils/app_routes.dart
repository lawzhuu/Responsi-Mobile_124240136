import 'package:flutter/material.dart';
import '../views/book_detail_view.dart';
import '../views/book_view.dart';
import '../views/favorite_spell.dart';
import '../views/login_screen.dart';
import '../views/profile_view.dart';
import '../views/spells_view.dart';

class AppRoutes {
  static const String login = '/login';
  static const String books = '/books';
  static const String bookDetail = '/book-detail';
  static const String spells = '/spells';
  static const String favoriteSpells = '/favorite-spells';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginView(),
    books: (context) => const BooksView(),
    spells: (context) => const SpellsView(),
    favoriteSpells: (context) => const FavoriteSpellsView(),
    profile: (context) => const ProfileView(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == bookDetail) {
      final bookIndex = settings.arguments as int?;
      if (bookIndex != null) {
        return MaterialPageRoute(
          builder: (context) => BookDetailView(bookIndex: bookIndex),
          settings: settings,
        );
      }
    }
    return null;
  }
}