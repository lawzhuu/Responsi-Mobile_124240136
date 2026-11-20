class Book {
  final int number;
  final String title;
  final String originalTitle;
  final String releaseDate;
  final String description;
  final int pages;
  final String cover;
  final int index;

  const Book({
    required this.number,
    required this.title,
    required this.originalTitle,
    required this.releaseDate,
    required this.description,
    required this.pages,
    required this.cover,
    required this.index,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      number: json['number'] is int
          ? json['number'] as int
          : int.tryParse(json['number']?.toString() ?? '0') ?? 0,
      title: (json['title'] as String?)?.trim() ?? 'Tanpa Judul',
      originalTitle: (json['originalTitle'] as String?)?.trim() ?? '-',
      releaseDate: (json['releaseDate'] as String?)?.trim() ?? '-',
      description: (json['description'] as String?)?.trim() ?? '-',
      pages: json['pages'] is int
          ? json['pages'] as int
          : int.tryParse(json['pages']?.toString() ?? '0') ?? 0,
      cover: (json['cover'] as String?)?.trim() ?? '',
      index: json['index'] is int
          ? json['index'] as int
          : int.tryParse(json['index']?.toString() ?? '0') ?? 0,
    );
  }
}