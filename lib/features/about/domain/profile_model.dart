class ProfileModel {
  final String profilePhoto;
  // Translated fields
  final String greeting;
  final String profileTitle;
  final String resume;
  final String aboutPassion;
  final String aboutDetails;

  ProfileModel({
    required this.profilePhoto,
    required this.greeting,
    required this.profileTitle,
    required this.resume,
    required this.aboutPassion,
    required this.aboutDetails,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final translations = json['paz1dv_translations'] as List;
    if (translations.isEmpty) {
      throw Exception('No translation found for profile');
    }
    final t = translations.first as Map<String, dynamic>;

    return ProfileModel(
      profilePhoto: json['profile_photo'] ?? '',
      greeting: t['greeting'] ?? '',
      profileTitle: t['title_mobile'] ?? '',
      resume: t['resume'] ?? '',
      aboutPassion: t['about_passion'] ?? '',
      aboutDetails: t['about_details'] ?? '',
    );
  }
}
