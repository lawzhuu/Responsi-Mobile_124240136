import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/character.dart';
import '../models/spells.dart';

class ApiService {
  static const String _baseUrl = 'https://potterapi-fedeperin.vercel.app/en/books';
  static const Duration _timeout = Duration(seconds: 15);

  /// Mengambil daftar karakter dari Potter API
  Future<List<Character>> fetchCharacters() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/character'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final dynamic decoded = json.decode(response.body);
        if (decoded is List) {
          return decoded
              .map((item) => Character.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          throw const FormatException('Format data karakter tidak sesuai.');
        }
      } else {
        throw HttpException(
            'Gagal memuat data karakter. Server merespons dengan status ${response.statusCode}');
      }
    } on SocketException {
      throw const SocketException('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on http.ClientException catch (e) {
      throw Exception('Kesalahan jaringan: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  /// Mengambil daftar spell dari Potter API
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
            'Gagal memuat data spell. Server merespons dengan status ${response.statusCode}');
      }
    } on SocketException {
      throw const SocketException('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on http.ClientException catch (e) {
      throw Exception('Kesalahan jaringan: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }
}
