import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/spells.dart';

class FavoriteService {
  static const String boxName = 'favorite_spells';

  /// Mengakses instance box Hive yang sudah terbuka
  Box get _box => Hive.box(boxName);

  bool isFavorite(int index) {
    return _box.containsKey(index);
  }

    /// Menambahkan spell ke dalam daftar favorit Hive
  Future<void> addFavorite(Spell spell) async {
    await _box.put(spell.index, spell.toMap());
  }

  Future<void> removeFavorite(int index) async {
    await _box.delete(index);
  }

  Future<bool> toggleFavorite(Spell spell) async {
    if (isFavorite(spell.index)) {
      await removeFavorite(spell.index);
      return false;
    } else {
      await addFavorite(spell);
      return true;
    }
  }

  /// Mengambil seluruh data spell favorit yang tersimpan di Hive
  List<Spell> getFavoriteSpells() {
    final list = <Spell>[];
    for (final key in _box.keys) {
      final dynamic raw = _box.get(key);
      if (raw != null && raw is Map) {
        list.add(Spell.fromMap(raw));
      }
    }
    list.sort((a, b) => a.index.compareTo(b.index));
    return list;
  }
  
  ValueListenable<Box> get listenable => _box.listenable();
}
