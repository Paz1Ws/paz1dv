import 'package:skeletonizer/skeletonizer.dart';

class ProfileModel {
  final int id;
  final String name;
  final String greeting;
  final String resume;
  final String profileTitle;
  final String aboutPassion;
  final String aboutDetails;
  final List<String> favoriteMusic; // Nueva lista de URLs de audio
  final List<String>
  favoriteMusicLogos; // Nueva lista de URLs de imágenes de álbumes

  ProfileModel({
    required this.id,
    required this.name,
    required this.greeting,
    required this.resume,
    required this.profileTitle,
    required this.aboutPassion,
    required this.aboutDetails,
    this.favoriteMusic = const [],
    this.favoriteMusicLogos = const [],
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final translations = json['paz1dv_translations'] as List;
    final translation = translations.isNotEmpty ? translations.first : null;

    return ProfileModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      greeting: translation?['greeting'] ?? '',
      resume: translation?['resume'] ?? '',
      profileTitle: translation?['title_mobile'] ?? '',
      aboutPassion: translation?['about_passion'] ?? '',
      aboutDetails: translation?['about_details'] ?? '',
      favoriteMusic: List<String>.from(json['favorite_music'] ?? []),
      favoriteMusicLogos: List<String>.from(json['favorite_music_logos'] ?? []),
    );
  }

  factory ProfileModel.fake() => ProfileModel(
    id: 0,
    name: BoneMock.words(2),
    greeting: BoneMock.words(2),
    resume: BoneMock.words(15),
    profileTitle: BoneMock.words(3),
    aboutPassion: BoneMock.words(8),
    aboutDetails: BoneMock.words(25),
    favoriteMusic: [],
    favoriteMusicLogos: [],
  );
}
