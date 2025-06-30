import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paz1dv/config/constants/responsive_constants.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/app/app_typography.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';
import 'package:paz1dv/config/gen/app_localizations.dart';
import 'package:paz1dv/config/gen/app_localizations_en.dart';
import 'package:paz1dv/features/home/presentation/screens/short_resume_statement.dart';
import 'package:paz1dv/features/home/presentation/widgets/burger_menu_button.dart';
import 'package:paz1dv/features/home/presentation/widgets/animated_signature.dart';
import 'package:paz1dv/features/home/presentation/widgets/remix_button.dart';
import 'package:paz1dv/features/home/presentation/widgets/interactive_profile_container.dart';
import 'package:paz1dv/features/home/presentation/widgets/scroll_indicator.dart';
import 'package:paz1dv/features/home/presentation/widgets/responsive_action_buttons.dart';
import 'package:paz1dv/shared/util/star_painter.dart';
import 'package:paz1dv/core/providers/data_providers.dart';

final customSwitchProvider = StateProvider<bool>((ref) => false);

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final switchValue = ref.watch(customSwitchProvider);
    final isNarrow = ResponsiveConstants.isNarrowScreen(context);
    final locale = Localizations.localeOf(context).languageCode;
    final profileAsync = ref.watch(profileProvider(locale));

    return Container(
      color: AppPalette.adaptiveColor(context),
      child: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (profile) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // App bar section
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isNarrow ? size.width * 0.05 : size.width * 0.2,
                vertical: isNarrow ? size.height * 0.05 : size.height * 0.08,
              ),
              child: Flexible(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: BurgerMenuButton(size: size),
                    ),
                    AnimatedSignature(
                      width: isNarrow ? size.width * 0.18 : size.width * 0.12,
                      height: isNarrow
                          ? size.height * 0.05
                          : size.height * 0.06,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ActionButtons(
                        size: size,
                        switchValue: switchValue,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Column(
              spacing: isNarrow ? size.height * 0.05 : size.height * 0.05,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Text(
                    profile.greeting,
                    style: AppTypography.overline(
                      context,
                      color: AppPalette.charcoalGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                InteractiveProfileContainer(
                  photoUrl: 'assets/images/paz1dv.webp',
                  profileTitle: profile.profileTitle,
                ),

                CustomPaint(
                  size: const Size(kIconSize32, kIconSize32),
                  painter: StarPainter(AppPalette.primaryColor(context)),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.1,
                    vertical: size.height * 0.02,
                  ),
                  child: Text(
                    profile.resume,
                    style: AppTypography.bodyMedium(
                      context,
                      color: AppPalette.reverseAdaptiveColor(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // ...existing code for ScrollIndicator, etc. if needed...
              ],
            ),
          ],
        ),
      ),
    );
  }
}
