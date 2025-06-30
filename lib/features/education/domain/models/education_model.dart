class EducationModel {
  final String title;
  final String description;
  final String imagePath;
  final String provider; // New parameter

  const EducationModel({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.provider,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    final translations = json['education_translations'] as List;
    if (translations.isEmpty) {
      throw Exception('No translation found for education ID: ${json['id']}');
    }
    final t = translations.first as Map<String, dynamic>;

    return EducationModel(
      imagePath: json['image_path'] ?? '',
      title: t['title'] ?? '',
      description: t['description'] ?? '',
      provider: t['provider'] ?? '', // expects provider in translation
    );
  }

  EducationModel copyWith({
    String? title,
    String? description,
    String? imagePath,
    String? provider,
  }) {
    return EducationModel(
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      provider: provider ?? this.provider,
    );
  }
}
