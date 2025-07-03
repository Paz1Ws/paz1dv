import 'package:dio/dio.dart';
import 'package:paz1dv/core/services/dio_client.dart';
import 'package:paz1dv/features/about/domain/profile_model.dart';
import 'package:paz1dv/features/education/domain/models/education_model.dart';
import 'package:paz1dv/features/experience/domain/experience_model.dart';
import 'package:paz1dv/features/skills/domain/skill_model.dart';

class ApiService {
  final Dio _dio = DioClient.instance;

  /// Fetches the profile data combined with its translation for a given locale.
  Future<ProfileModel> fetchProfile(String locale) async {
    try {
      final response = await _dio.get(
        '/paz1dv?select=*,paz1dv_translations(*)&paz1dv_translations.locale=eq.$locale&limit=1',
      );
      // Supabase returns a list, we take the first element.
      final data = (response.data as List).first;
      return ProfileModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to load profile data: $e');
    }
  }

  /// Fetches a list of experiences combined with their translations.
  Future<List<ExperienceModel>> fetchExperiences(String locale) async {
    try {
      final response = await _dio.get(
        '/experiences?select=*,experience_translations(*)&experience_translations.locale=eq.$locale',
      );
      final data = response.data as List;
      return data.map((item) => ExperienceModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to load experiences: $e');
    }
  }

  /// Fetches a list of skills.
  Future<List<SkillModel>> fetchSkills() async {
    try {
      final response = await _dio.get(
        '/skills', // No translations join needed
      );
      final data = response.data as List;
      return data.map((item) => SkillModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to load skills: $e');
    }
  }

  /// Fetches a list of education items combined with their translations.
  Future<List<EducationModel>> fetchEducation(String locale) async {
    try {
      final response = await _dio.get(
        '/education?select=*,education_translations(*)&education_translations.locale=eq.$locale',
      );
      final data = response.data as List;
      return data.map((item) => EducationModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to load education data: $e');
    }
  }
}
