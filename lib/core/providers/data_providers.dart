import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paz1dv/core/services/paz1dv_http_requests.dart';
import 'package:paz1dv/features/about/domain/profile_model.dart';
import 'package:paz1dv/features/education/domain/models/education_model.dart';
import 'package:paz1dv/features/experience/domain/experience_model.dart';
import 'package:paz1dv/features/skills/domain/skill_model.dart';

/// Provider for the ApiService instance.
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

/// Provider to fetch profile data. It depends on a locale.
final profileProvider = FutureProvider.family<ProfileModel, String>((
  ref,
  locale,
) {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.fetchProfile(locale);
});

/// Provider to fetch the list of experiences. It depends on a locale.
final experiencesProvider =
    FutureProvider.family<List<ExperienceModel>, String>((ref, locale) {
      final apiService = ref.watch(apiServiceProvider);
      return apiService.fetchExperiences(locale);
    });
final skillsProvider = FutureProvider<List<SkillModel>>((ref) async {
  return ApiService().fetchSkills();
});
final educationProvider = FutureProvider.family<List<EducationModel>, String>((
  ref,
  locale,
) {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.fetchEducation(locale);
});
