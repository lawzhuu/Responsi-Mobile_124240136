class Character {
  final int index;
  final String fullName;
  final String nickname;
  final String hogwartsHouse;
  final String interpretedBy;
  final List<String> children;
  final String image;
  final String birthdate;

  const Character({
    required this.index,
    required this.fullName,
    required this.nickname,
    required this.hogwartsHouse,
    required this.interpretedBy,
    required this.children,
    required this.image,
    required this.birthdate,
  });

  // Membuat objek Character dari data JSON API
  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      index: json['index'] is int
          ? json['index'] as int
          : int.tryParse(json['index']?.toString() ?? '0') ?? 0,
      fullName: (json['fullName'] as String?)?.trim() ?? 'Karakter Tidak Dikenal',
      nickname: (json['nickname'] as String?)?.trim() ?? '',
      hogwartsHouse: (json['hogwartsHouse'] as String?)?.trim() ?? 'Unknown',
      interpretedBy: (json['interpretedBy'] as String?)?.trim() ?? '',
      children: (json['children'] as List<dynamic>?)
              ?.map((e) => e.toString().trim())
              .where((name) => name.isNotEmpty)
              .toList() ??
          <String>[],
      image: (json['image'] as String?)?.trim() ?? '',
      birthdate: (json['birthdate'] as String?)?.trim() ?? '',
    );
  }

  // Mengubah objek Character ke dalam Map/JSON
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'fullName': fullName,
      'nickname': nickname,
      'hogwartsHouse': hogwartsHouse,
      'interpretedBy': interpretedBy,
      'children': children,
      'image': image,
      'birthdate': birthdate,
    };
  }
}
