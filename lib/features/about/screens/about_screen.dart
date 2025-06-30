import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/constants/responsive_constants.dart';
import 'package:paz1dv/core/providers/data_providers.dart';
import 'package:paz1dv/features/about/widgets/about_text_content.dart';
import 'package:paz1dv/features/about/widgets/profile_image_card.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final isNarrow = ResponsiveConstants.isNarrowScreen(context);
    final locale = Localizations.localeOf(context).languageCode;

    final profileAsync = ref.watch(profileProvider(locale));

    return Container(
      width: size.width,
      color: AppPalette.adaptiveColor(context),
      child: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (profile) => isNarrow
            ? _buildMobileLayout(size, isNarrow, profile)
            : _buildDesktopLayout(size, isNarrow, profile),
      ),
    );
  }

  Widget _buildDesktopLayout(Size size, bool isNarrow, profile) {
    return SizedBox(
      height: size.height * 0.8,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: size.width * 0.06,
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: ProfileImageCard(size: size, isNarrow: isNarrow),
            ),
          ),
          Expanded(
            flex: 3,
            child: AboutTextContent(
              size: size,
              isNarrow: isNarrow,
              aboutPassion: profile.aboutPassion,
              aboutDetails: profile.aboutDetails,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(Size size, bool mobile, profile) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: size.height * 0.1,
      children: [
        ProfileImageCard(size: size, isNarrow: mobile),
        AboutTextContent(
          size: size,
          isNarrow: mobile,
          aboutPassion: profile.aboutPassion,
          aboutDetails: profile.aboutDetails,
        ),
      ],
    );
  }
}
