import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/book.dart';
import '../models/spells.dart';

class ApiService {
  static const String _baseUrl = 'https://potterapi-fedeperin.vercel.app/en';
  static const Duration _timeout = Duration(seconds: 15);

  /// Mengambil daftar buku dari Potter API
  Future<List<Book>> fetchBooks() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/books'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final dynamic decoded = json.decode(response.body);
        if (decoded is List) {
          return decoded
              .map((item) => Book.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          throw const FormatException('Format data buku tidak sesuai.');
        }
      } else {
        throw HttpException(
            'Gagal memuat data buku. Status: ${response.statusCode}');
      }
    } on SocketException {
      throw const SocketException('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on http.ClientException catch (e) {
      throw Exception('Kesalahan jaringan: ${e.message}');
    }
  }

  /// Mengambil detail 1 buku berdasarkan index (?index=...)
  Future<Book> fetchBookDetail(int index) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/books?index=$index'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final dynamic decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic>) {
          return Book.fromJson(decoded);
        } else if (decoded is List && decoded.isNotEmpty) {
          return Book.fromJson(decoded.first as Map<String, dynamic>);
        } else {
          throw const FormatException('Format detail buku tidak sesuai.');
        }
      } else {
        throw HttpException(
            'Gagal memuat detail buku. Status: ${response.statusCode}');
      }
    } on SocketException {
      throw const SocketException('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on http.ClientException catch (e) {
      throw Exception('Kesalahan jaringan: ${e.message}');
    }
  }

  /// Mengambil daftar spell dari Potter API (tetap sama)
  Future<List<Spell>> fetchSpells() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/spells'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final dynamic decoded = json.decode(response.body);
        if (decoded is List) {
          return decoded
              .map((item) => Spell.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          throw const FormatException('Format data spell tidak sesuai.');
        }
      } else {
        throw HttpException(
            'Gagal memuat data spell. Status: ${response.statusCode}');
      }
    } on SocketException {
      throw const SocketException('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on http.ClientException catch (e) {
      throw Exception('Kesalahan jaringan: ${e.message}');
    }
  }
}