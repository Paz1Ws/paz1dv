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
import 'package:paz1dv/features/portfolio_controller_providers.dart';
import 'package:paz1dv/features/skills/screens/skills_screen.dart';
import 'package:paz1dv/shared/widgets/section_divider.dart';

class PortfolioHomeScreen extends ConsumerStatefulWidget {
  const PortfolioHomeScreen({super.key});

  @override
  ConsumerState<PortfolioHomeScreen> createState() =>
      _PortfolioHomeScreenState();
}

class _PortfolioHomeScreenState extends ConsumerState<PortfolioHomeScreen> {
  final Map<PortfolioSection, GlobalKey> _sectionKeys = {
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

    final localizations = AppLocalizations.of(context)!;
    final size = MediaQuery.sizeOf(context);
    final isNarrow = ResponsiveConstants.isNarrowScreen(context);

    return Scaffold(
      backgroundColor: AppPalette.adaptiveColor(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ProfileScreen(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isNarrow ? size.width * 0.05 : size.width * 0.08,
                vertical: isNarrow ? size.height * 0.05 : size.height * 0.08,
              ),
              child: Column(
                children: [
                  Column(
                    key: _sectionKeys[PortfolioSection.about],
                    children: [
                      SectionDivider(title: localizations.aboutLabel),
                      const AboutScreen(),
                    ],
                  ),
                  Column(
                    key: _sectionKeys[PortfolioSection.education],
                    children: [
                      SectionDivider(title: localizations.educationLabel),
                      const EducationScreen(),
                    ],
                  ),
                  Column(
                    key: _sectionKeys[PortfolioSection.experience],
                    children: [
                      SectionDivider(title: localizations.experienceLabel),
                      const ExperienceScreen(),
                    ],
                  ),
                  Column(
                    key: _sectionKeys[PortfolioSection.skills],
                    children: [
                      SectionDivider(title: localizations.skillsLabel),
                      const SkillsScreen(),
                    ],
                  ),
                  Column(
                    key: _sectionKeys[PortfolioSection.contact],
                    children: [
                      SectionDivider(title: localizations.contactLabel),
                      const ContactScreen(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
