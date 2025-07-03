import 'package:skeletonizer/skeletonizer.dart';

class SkillModel {
  final String name;
  final String? logoUrl;

  SkillModel({required this.name, this.logoUrl});

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      name: json['name'] as String,
      logoUrl: json['logo_url'] as String?,
    );
  }

  factory SkillModel.fake() => SkillModel(name: BoneMock.name, logoUrl: '');
}
