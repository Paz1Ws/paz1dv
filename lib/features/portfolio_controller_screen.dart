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
  final Map<PortfolioSection, GlobalKey> _sectionKeys = {
    PortfolioSection.profile: GlobalKey(),
    PortfolioSection.about: GlobalKey(),
    PortfolioSection.education: GlobalKey(),
    PortfolioSection.experience: GlobalKey(),
    PortfolioSection.skills: GlobalKey(),
    PortfolioSection.contact: GlobalKey(),
  };

  void _scrollToSection(PortfolioSection section) {
    final context = _sectionKeys[section]?.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  List<Widget> _buildSectionList(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final size = MediaQuery.sizeOf(context);
    final isNarrow = ResponsiveConstants.isNarrowScreen(context);

    return [
      // Profile section
      ProfileScreen(key: _sectionKeys[PortfolioSection.profile]!),
      // About section
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isNarrow ? size.width * 0.05 : size.width * 0.08,
        ),
        child: Column(
          key: _sectionKeys[PortfolioSection.about],
          children: [
            SectionDivider(title: localizations.aboutLabel),
            const AboutScreen(),
          ],
        ),
      ),
      // Education section
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isNarrow ? size.width * 0.05 : size.width * 0.08,
        ),
        child: Column(
          key: _sectionKeys[PortfolioSection.education],
          children: [
            SectionDivider(title: localizations.educationLabel),
            const EducationScreen(),
          ],
        ),
      ),
      // Experience section
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isNarrow ? size.width * 0.05 : size.width * 0.08,
        ),
        child: Column(
          key: _sectionKeys[PortfolioSection.experience],
          children: [
            SectionDivider(title: localizations.experienceLabel),
            const ExperienceScreen(),
          ],
        ),
      ),
      // Skills section
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isNarrow ? size.width * 0.05 : size.width * 0.08,
        ),
        child: Column(
          key: _sectionKeys[PortfolioSection.skills],
          children: [
            SectionDivider(title: localizations.skillsLabel),
            const SkillsScreen(),
          ],
        ),
      ),
      // Contact divider
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isNarrow ? size.width * 0.05 : size.width * 0.08,
        ),
        child: SectionDivider(title: localizations.contactLabel),
      ),
      // Contact section
      ContactScreen(key: _sectionKeys[PortfolioSection.contact]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<PortfolioSection?>(scrollTargetProvider, (previous, next) {
      if (next != null) {
        _scrollToSection(next);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(scrollTargetProvider.notifier).state = null;
        });
      }
    });

    // Listen to remix button state to manage global indicator
    ref.listen<bool>(remixButtonTappedProvider, (previous, next) {
      if (next == false) {
        // When remix button is disabled, hide global indicator
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
            itemCount: sections.length,
            itemBuilder: (context, index) {
              return sections[index];
            },
          ),
        ),

        Align(
          alignment: Alignment.centerRight,
          child: Column(
            spacing: kSpacing12,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!isNarrow && showRemix == false)
                Padding(
                  padding: const EdgeInsets.only(right: 46.0, bottom: 36.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: ScrollToTopButton(
                      onTap: () => _scrollToSection(PortfolioSection.profile),
                    ),
                  ),
                ),
              if (audioState.currentBand != null &&
                  (showRemix || audioState.isPlaying))
                Positioned(
                  bottom: isNarrow ? 20 : 10,
                  right: isNarrow ? 20 : 40,
                  left: isNarrow ? 20 : null,
                  child: isNarrow
                      ? Padding(
                          padding: const EdgeInsets.all(kSpacing12),
                          child: Row(
                            spacing: kSpacing8,
                            children: [
                              Expanded(
                                child: GlobalPlayingIndicator(size: size),
                              ),
                              ScrollToTopButton(
                                onTap: () =>
                                    _scrollToSection(PortfolioSection.profile),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          spacing: kSpacing12,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (!isNarrow || audioState.currentBand == null)
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: ScrollToTopButton(
                                  onTap: () => _scrollToSection(
                                    PortfolioSection.profile,
                                  ),
                                ),
                              ),
                            GlobalPlayingIndicator(size: size),
                          ],
                        ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
