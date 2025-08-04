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

final experienceAnimationPlayedProvider = StateProvider<bool>((ref) => false);

class ExperienceScreen extends ConsumerStatefulWidget {
  const ExperienceScreen({super.key});

  @override
  ConsumerState<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends ConsumerState<ExperienceScreen> {
  final _experienceSectionKey = GlobalKey();
  final bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedExperience = ref.watch(selectedExperienceProvider);
    final size = MediaQuery.sizeOf(context);
    final locale = Localizations.localeOf(context).languageCode;

    final experiencesAsync = ref.watch(experiencesProvider(locale));

    return Container(
      key: _experienceSectionKey,
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
              ? ExperienceGrid(
                  key: const ValueKey('grid'),
                  experienceItems: experiences,
                  size: size,
                  animate: _hasAnimated,
                )
              : ExperienceDetailView(
                  key: ValueKey(selectedExperience.title),
                  item: selectedExperience,
                  animate: _hasAnimated,
                  onBack: () =>
                      ref.read(selectedExperienceProvider.notifier).state =
                          null,
                ),
        ),
      ),
    );
  }
}
