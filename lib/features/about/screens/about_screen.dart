import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/constants/responsive_constants.dart';
import 'package:paz1dv/core/providers/data_providers.dart';
import 'package:paz1dv/features/about/widgets/about_text_content.dart';
import 'package:paz1dv/features/about/widgets/profile_image_card.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:paz1dv/features/about/domain/profile_model.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;
    final profileAsync = ref.watch(profileProvider(locale));

    return Container(
      width: MediaQuery.sizeOf(context).width,
      color: AppPalette.adaptiveColor(context),
      child: profileAsync.when(
        loading: () =>
            Skeletonizer(child: _AboutContent(profile: ProfileModel.fake())),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (profile) => _AboutContent(profile: profile),
      ),
    );
  }
}

class _AboutContent extends StatelessWidget {
  final ProfileModel profile;
  const _AboutContent({required this.profile});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isNarrow = ResponsiveConstants.isNarrowScreen(context);
    return isNarrow
        ? MobileLayout(size: size, profile: profile)
        : DesktopLayout(size: size, profile: profile);
  }
}

class DesktopLayout extends StatelessWidget {
  final Size size;
  final ProfileModel profile;

  const DesktopLayout({super.key, required this.size, required this.profile});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.8,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: size.width * 0.06,
        children: [
          Expanded(
            flex: 2,
            child: Center(child: ProfileImageCard(size: size, isNarrow: false)),
          ),
          Expanded(
            flex: 3,
            child: AboutTextContent(
              size: size,
              isNarrow: false,
              aboutPassion: profile.aboutPassion,
              aboutDetails: profile.aboutDetails,
            ),
          ),
        ],
      ),
    );
  }
}

class MobileLayout extends StatelessWidget {
  final Size size;
  final ProfileModel profile;

  const MobileLayout({super.key, required this.size, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: size.height * 0.05,
      children: [
        ProfileImageCard(size: size, isNarrow: true),
        AboutTextContent(
          size: size,
          isNarrow: true,
          aboutPassion: profile.aboutPassion,
          aboutDetails: profile.aboutDetails,
        ),
        // Social media debajo en móvil
      ],
    );
  }
}
