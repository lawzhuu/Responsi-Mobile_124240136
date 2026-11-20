import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_services.dart';
import '../services/auth_services.dart';
import '../utils/app_routes.dart';
import '../utils/app_theme.dart';
import '../widgets/book_card.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';

class BooksView extends StatefulWidget {
  const BooksView({super.key});

  @override
  State<BooksView> createState() => _BooksViewState();
}

class _BooksViewState extends State<BooksView> {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();
  late Future<List<Book>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() {
    setState(() {
      _booksFuture = _apiService.fetchBooks();
    });
  }

  Future<void> _handleLogout() async {
    await _authService.logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harry Potter Books'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_rounded),
            tooltip: 'Profile',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: FutureBuilder<List<Book>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MagicalLoadingWidget(message: 'Memuat daftar buku...');
          }
          if (snapshot.hasError) {
            return MagicalErrorWidget(
              message: snapshot.error.toString().replaceAll('Exception:', '').trim(),
              onRetry: _loadBooks,
            );
          }
          final books = snapshot.data ?? [];
          if (books.isEmpty) {
            return const Center(
              child: Text('Buku tidak ditemukan.', style: TextStyle(color: AppTheme.textMuted)),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemCount: books.length,
            itemBuilder: (context, i) {
              final book = books[i];
              return BookCard(
                book: book,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.bookDetail,
                    arguments: book.index,
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
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_rounded), label: 'Books'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_fix_high_rounded), label: 'Spells'),
          BottomNavigationBarItem(icon: Icon(Icons.star_rounded), label: 'Favorites'),
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