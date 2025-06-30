import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/core/providers/data_providers.dart';
import 'package:paz1dv/features/experience/domain/experience_model.dart';
import 'package:paz1dv/features/experience/widgets/experience_detail_view.dart';
import 'package:paz1dv/features/experience/widgets/experience_grid.dart';

final selectedExperienceProvider = StateProvider<ExperienceModel?>(
  (ref) => null,
);

class ExperienceScreen extends ConsumerWidget {
  const ExperienceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedExperience = ref.watch(selectedExperienceProvider);
    final size = MediaQuery.sizeOf(context);
    final locale = Localizations.localeOf(context).languageCode;

    // Use the experiences provider to fetch data from API
    final experiencesAsync = ref.watch(experiencesProvider(locale));

    return Container(
      color: AppPalette.adaptiveColor(context),
      child: experiencesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Error loading experiences: $error')),
        data: (experiences) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: selectedExperience == null
              ? ExperienceGrid(experienceItems: experiences, size: size)
              : ExperienceDetailView(
                  key: ValueKey(selectedExperience.title),
                  item: selectedExperience,
                  onBack: () =>
                      ref.read(selectedExperienceProvider.notifier).state =
                          null,
                ),
        ),
      ),
    );
  }
}
