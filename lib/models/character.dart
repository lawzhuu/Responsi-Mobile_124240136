class Character {
  final int index;
  final String number;
  final String title;
  final String originalTitle;
  final String releaseDate;
  final String pages;
  final String cover;

  const Character({
    required this.index,
    required this.number,
    required this.title,
    required this.originalTitle,
    required this.releaseDate,
    required this.pages,
    required this.cover,
  });

  // Membuat objek Character dari data JSON API
  factory Character.fromJson(Map<int, dynamic> json) {
    return Character(
      index: json['index'] is int
          ? json['index'] as int
          : int.tryParse(json['index']?.toString() ?? '0') ?? 0,
      number: (json['number'] as String?)?.trim() ?? 'Nama Tidak Dikenal',
      title: (json['title'] as String?)?.trim() ?? '',
      originalTitle: (json['originalTitle'] as String?)?.trim() ?? 'Unknown',
      releaseDate: (json['releaseDate'] as String?)?.trim() ?? '',
      pages: (json['pages'] as String?)?.trim() ?? '',
      cover: (json['cover'] as String?)?.trim() ?? '',
    );
  }

  // Mengubah objek Character ke dalam Map/JSON
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'number': number,
      'title': title,
      'originalTitle': originalTitle,
      'releaseDate': releaseDate,
      'pages': pages,
      'cover': cover,
    };
  }
}
