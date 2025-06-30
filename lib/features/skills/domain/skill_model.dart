class SkillModel {
  final String imagePath;
  // Translated fields
  final String title;
  final String description;

  SkillModel({
    required this.imagePath,
    required this.title,
    required this.description,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    final translations = json['skill_translations'] as List;
    if (translations.isEmpty) {
      throw Exception('No translation found for skill ID: ${json['id']}');
    }
    final t = translations.first as Map<String, dynamic>;

    return SkillModel(
      imagePath: json['image_path'] ?? '',
      title: t['title'] ?? '',
      description: t['description'] ?? '',
    );
  }
}
