class Spell {
  final int index;
  final String spell;
  final String use;

  const Spell({
    required this.index,
    required this.spell,
    required this.use,
  });

  String get name => spell;
  String get description => use;

  // Membuat objek Spell dari data JSON API
  factory Spell.fromJson(Map<String, dynamic> json) {
    return Spell(
      index: json['index'] is int
          ? json['index'] as int
          : int.tryParse(json['index']?.toString() ?? '0') ?? 0,
      spell: (json['spell'] as String?)?.trim() ?? 'Spell Tidak Dikenal',
      use: (json['use'] as String?)?.trim() ?? 'Tidak ada deskripsi',
    );
  }

  // Membuat objek Spell dari data Map Hive
  factory Spell.fromMap(Map<dynamic, dynamic> map) {
    return Spell(
      index: map['index'] is int
          ? map['index'] as int
          : int.tryParse(map['index']?.toString() ?? '0') ?? 0,
      spell: (map['spell'] as String?)?.trim() ?? 'Spell Tidak Dikenal',
      use: (map['use'] as String?)?.trim() ?? 'Tidak ada deskripsi',
    );
  }

  // Mengubah objek Spell ke format Map untuk disimpan di Hive
  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'spell': spell,
      'use': use,
    };
  }

  Map<String, dynamic> toJson() => toMap();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Spell &&
          runtimeType == other.runtimeType &&
          index == other.index &&
          spell == other.spell;

  @override
  int get hashCode => index.hashCode ^ spell.hashCode;
}
