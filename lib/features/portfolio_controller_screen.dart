import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';
import 'package:paz1dv/config/constants/responsive_constants.dart';
import 'package:paz1dv/config/gen/app_localizations.dart';
import 'package:paz1dv/features/about/screens/about_screen.dart';
import 'package:paz1dv/features/contact/screens/contact_screen.dart';
import 'package:paz1dv/features/education/screens/education_screen.dart';
import 'package:paz1dv/features/experience/screens/experience_screen.dart';
import 'package:paz1dv/features/home/presentation/screens/profile_screen.dart';
import 'package:paz1dv/features/home/presentation/widgets/global_playing_indicator.dart';
import 'package:paz1dv/features/home/presentation/widgets/action_buttons.dart';
import 'package:paz1dv/features/home/presentation/widgets/scroll_to_top_button.dart';
import 'package:paz1dv/features/portfolio_controller_providers.dart';
import 'package:paz1dv/features/skills/screens/skills_screen.dart';
import 'package:paz1dv/shared/widgets/section_divider.dart';
import 'package:paz1dv/core/services/audio_player_service.dart';

class PortfolioHomeScreen extends ConsumerStatefulWidget {
  const PortfolioHomeScreen({super.key});

  @override
  ConsumerState<PortfolioHomeScreen> createState() =>
      _PortfolioHomeScreenState();
}

class _PortfolioHomeScreenState extends ConsumerState<PortfolioHomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(PortfolioSection section) {
    final targetIndex = sectionToIndexMap[section];
    if (targetIndex != null) {
      ref.read(scrollToIndexProvider.notifier).state = targetIndex;
    }
  }

  List<Widget> _buildSectionList(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final size = MediaQuery.sizeOf(context);
    final isNarrow = ResponsiveConstants.isNarrowScreen(context);

    return [
      // 0: Profile section
      const ProfileScreen(),

      // 1: About section
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isNarrow ? size.width * 0.05 : size.width * 0.08,
        ),
        child: Column(
          children: [
            SectionDivider(title: localizations.aboutLabel),
            const AboutScreen(),
          ],
        ),
      ),

      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isNarrow ? size.width * 0.05 : size.width * 0.08,
        ),
        child: Column(
          children: [
            SectionDivider(title: localizations.experienceLabel),
            const ExperienceScreen(),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isNarrow ? size.width * 0.05 : size.width * 0.08,
        ),
        child: Column(
          children: [
            SectionDivider(title: localizations.educationLabel),
            const EducationScreen(),
          ],
        ),
      ),
      // 4: Skills section
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isNarrow ? size.width * 0.05 : size.width * 0.08,
        ),
        child: Column(
          children: [
            SectionDivider(title: localizations.skillsLabel),
            const SkillsScreen(),
          ],
        ),
      ),

      // 5: Contact divider
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isNarrow ? size.width * 0.05 : size.width * 0.08,
        ),
        child: SectionDivider(title: localizations.contactLabel),
      ),

      // 6: Contact section
      const ContactScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Escuchar cambios de scroll target
    ref.listen<PortfolioSection?>(scrollTargetProvider, (previous, next) {
      if (next != null) {
        _scrollToSection(next);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(scrollTargetProvider.notifier).state = null;
        });
      }
    });

    // Escuchar cambios de scroll por índice
    ref.listen<int?>(scrollToIndexProvider, (previous, next) {
      if (next != null && _scrollController.hasClients) {
        // Scroll suave al índice
        final itemHeight = MediaQuery.sizeOf(context).height;
        final targetOffset = next * itemHeight;

        _scrollController.animateTo(
          targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOutCubic,
        );

        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(scrollToIndexProvider.notifier).state = null;
        });
      }
    });

    ref.listen<bool>(remixButtonTappedProvider, (previous, next) {
      if (next == false) {
        ref.read(audioStateProvider.notifier).stopPlaying();
      }
    });

    final size = MediaQuery.sizeOf(context);
    final isNarrow = ResponsiveConstants.isNarrowScreen(context);
    final audioState = ref.watch(audioStateProvider);
    final showRemix = ref.watch(remixButtonTappedProvider);
    final sections = _buildSectionList(context);

    return Stack(
      children: [
        // Main content
        Scaffold(
          backgroundColor: AppPalette.adaptiveColor(context),
          body: ListView.builder(
            controller: _scrollController,
            itemCount: sections.length,
            itemBuilder: (context, index) {
              return sections[index];
            },
          ),
        ),

        if (!isNarrow && showRemix == false)
          Positioned(
            right: 46.0,
            bottom: 36.0,
            child: ScrollToTopButton(
              onTap: () => _scrollToSection(PortfolioSection.profile),
            ),
          ),

        if (audioState.currentBand != null &&
            (showRemix || audioState.isPlaying))
          Positioned(
            bottom: isNarrow ? 20 : 10,
            right: isNarrow ? 20 : 40,
            left: isNarrow ? 20 : null,
            child: isNarrow
                ? Row(
                    spacing: kSpacing8,
                    children: [
                      Expanded(child: GlobalPlayingIndicator(size: size)),
                      ScrollToTopButton(
                        onTap: () => _scrollToSection(PortfolioSection.profile),
                      ),
                    ],
                  )
                : Column(
                    spacing: kSpacing12,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isNarrow || audioState.currentBand == null)
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: ScrollToTopButton(
                            onTap: () =>
                                _scrollToSection(PortfolioSection.profile),
                          ),
                        ),
                      GlobalPlayingIndicator(size: size),
                    ],
                  ),
          ),
      ],
    );
  }
}
