import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_services.dart';
import '../utils/app_theme.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';

class BookDetailView extends StatefulWidget {
  final int bookIndex;

  const BookDetailView({super.key, required this.bookIndex});

  @override
  State<BookDetailView> createState() => _BookDetailViewState();
}

class _BookDetailViewState extends State<BookDetailView> {
  final ApiService _apiService = ApiService();
  late Future<Book> _bookFuture;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  void _loadDetail() {
    setState(() {
      _bookFuture = _apiService.fetchBookDetail(widget.bookIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Buku')),
      body: FutureBuilder<Book>(
        future: _bookFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MagicalLoadingWidget(message: 'Memuat detail buku...');
          }
          if (snapshot.hasError) {
            return MagicalErrorWidget(
              message: snapshot.error.toString().replaceAll('Exception:', '').trim(),
              onRetry: _loadDetail,
            );
          }
          final book = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      book.cover,
                      height: 280,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.menu_book, size: 100, color: AppTheme.antiqueGold),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  book.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppTheme.antiqueGold,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _infoTile('Original Title', book.originalTitle),
                _infoTile('Book Number', '#${book.number} (Index: ${book.index})'),
                _infoTile('Release Date', book.releaseDate),
                _infoTile('Total Pages', '${book.pages} pages'),
                _infoTile('Description', book.description),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(color: AppTheme.textLight, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}