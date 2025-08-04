import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/constants/responsive_constants.dart';
import 'package:paz1dv/core/providers/data_providers.dart';
import 'package:paz1dv/features/about/widgets/about_text_content.dart';
import 'package:paz1dv/features/about/widgets/profile_image_card.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:paz1dv/features/about/domain/profile_model.dart';

final aboutAnimationPlayedProvider = StateProvider<bool>((ref) => false);

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

class _AboutContent extends ConsumerStatefulWidget {
  final ProfileModel profile;
  const _AboutContent({required this.profile});

  @override
  ConsumerState<_AboutContent> createState() => _AboutContentState();
}

class _AboutContentState extends ConsumerState<_AboutContent> {
  final _aboutSectionKey = GlobalKey();
  final bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isNarrow = ResponsiveConstants.isNarrowScreen(context);

    return Container(
      key: _aboutSectionKey,
      child: isNarrow
          ? MobileLayout(
              size: size,
              profile: widget.profile,
              animate: _hasAnimated,
            )
          : DesktopLayout(
              size: size,
              profile: widget.profile,
              animate: _hasAnimated,
            ),
    );
  }
}

class DesktopLayout extends StatelessWidget {
  final Size size;
  final ProfileModel profile;
  final bool animate;

  const DesktopLayout({
    super.key,
    required this.size,
    required this.profile,
    required this.animate,
  });

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
            child: Center(
              child: animate
                  ? FadeInLeft(
                      duration: const Duration(milliseconds: 800),
                      child: ProfileImageCard(size: size, isNarrow: false),
                    )
                  : ProfileImageCard(size: size, isNarrow: false),
            ),
          ),
          Expanded(
            flex: 3,
            child: animate
                ? FadeInRight(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 200),
                    child: AboutTextContent(
                      size: size,
                      isNarrow: false,
                      aboutPassion: profile.aboutPassion,
                      aboutDetails: profile.aboutDetails,
                      animate: animate,
                    ),
                  )
                : AboutTextContent(
                    size: size,
                    isNarrow: false,
                    aboutPassion: profile.aboutPassion,
                    aboutDetails: profile.aboutDetails,
                    animate: animate,
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
  final bool animate;

  const MobileLayout({
    super.key,
    required this.size,
    required this.profile,
    required this.animate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: size.height * 0.05,
      children: [
        // Apply FadeInDown animation to ProfileImageCard
        animate
            ? FadeInDown(
                duration: const Duration(milliseconds: 800),
                child: ProfileImageCard(size: size, isNarrow: true),
              )
            : ProfileImageCard(size: size, isNarrow: true),

        // Apply FadeInUp animation to AboutTextContent
        animate
            ? FadeInUp(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 300),
                child: AboutTextContent(
                  size: size,
                  isNarrow: true,
                  aboutPassion: profile.aboutPassion,
                  aboutDetails: profile.aboutDetails,
                  animate: animate,
                ),
              )
            : AboutTextContent(
                size: size,
                isNarrow: true,
                aboutPassion: profile.aboutPassion,
                aboutDetails: profile.aboutDetails,
                animate: animate,
              ),
      ],
    );
  }
}
