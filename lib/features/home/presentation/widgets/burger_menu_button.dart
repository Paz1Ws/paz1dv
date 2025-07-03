import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paz1dv/config/app/app_config_providers.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/constants/responsive_constants.dart';
import 'package:paz1dv/config/app/app_typography.dart';
import 'package:paz1dv/config/gen/app_localizations.dart';
import 'package:paz1dv/features/portfolio_controller_providers.dart';

final toggleBurgerMenuProvider = StateProvider<bool>((ref) => false);
final isBurgerMenuTappedProvider = StateProvider<bool>((ref) => false);

class BurgerMenuButton extends ConsumerWidget {
  final Size size;
  const BurgerMenuButton({super.key, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHovered = ref.watch(toggleBurgerMenuProvider);
    final isTapped = ref.watch(isBurgerMenuTappedProvider);
    final isNarrow = ResponsiveConstants.isNarrowScreen(context);

    // Use size parameter and constants instead of hardcoded values
    final containerWidth = isNarrow ? size.width * 0.06 : size.width * 0.025;
    final containerHeight = isNarrow ? size.height * 0.03 : size.height * 0.025;
    final barHeight = isNarrow ? kStroke3 : kStroke4;

    return GestureDetector(
      onTap: () {
        final isTapped = ref.read(isBurgerMenuTappedProvider);
        ref.read(isBurgerMenuTappedProvider.notifier).state = !isTapped;

        if (!isTapped) {
          showGeneralDialog(
            context: context,
            barrierDismissible: true,
            barrierLabel: 'Menu',
            transitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (context, anim1, anim2) {
              return const _BurgerMenuOverlay();
            },
            transitionBuilder: (context, anim1, anim2, child) {
              return FadeTransition(opacity: anim1, child: child);
            },
          ).then((_) {
            ref.read(isBurgerMenuTappedProvider.notifier).state = false;
          });
        }
      },
      child: MouseRegion(
        onEnter: (_) {
          if (!isTapped) {
            ref.read(toggleBurgerMenuProvider.notifier).state = true;
          }
        },
        onExit: (_) {
          if (!isTapped) {
            ref.read(toggleBurgerMenuProvider.notifier).state = false;
          }
        },
        child: SizedBox(
          width: containerWidth,
          height: containerHeight,
          child: Stack(
            children: [
              // First bar - maintains proportional sizing
              AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                top: isTapped ? containerHeight * 0.42 : 0,
                left: 0,
                child: AnimatedRotation(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                  turns: isTapped ? 0.125 : 0,
                  child: _BurgerBar(
                    isHovered: isHovered,
                    isTapped: isTapped,
                    width: isTapped
                        ? containerWidth * 1.2
                        : (isHovered
                              ? containerWidth * 0.85
                              : containerWidth * 1.0),
                    height: barHeight,
                    borderRadius: barHeight * 2,
                  ),
                ),
              ),

              // Middle bar
              AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                top: containerHeight * 0.42,
                left: 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: isTapped ? 0.0 : 1.0,
                  child: _BurgerBar(
                    isHovered: isHovered,
                    isTapped: isTapped,
                    width: isHovered
                        ? containerWidth * 0.85
                        : containerWidth * 0.5,
                    height: barHeight,
                    borderRadius: barHeight * 2,
                  ),
                ),
              ),

              // Last bar
              AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                top: isTapped ? containerHeight * 0.42 : containerHeight * 0.83,
                left: 0,
                child: AnimatedRotation(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                  turns: isTapped ? -0.125 : 0,
                  child: _BurgerBar(
                    isHovered: isHovered,
                    isTapped: isTapped,
                    width: isTapped
                        ? containerWidth * 1.2
                        : (isHovered
                              ? containerWidth * 0.85
                              : containerWidth * 0.8),
                    height: barHeight,
                    borderRadius: barHeight * 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BurgerBar extends StatelessWidget {
  final bool isHovered;
  final bool isTapped;
  final double width;
  final double height;
  final double borderRadius;

  const _BurgerBar({
    required this.isHovered,
    required this.isTapped,
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isTapped
            ? AppPalette.crimsonRed
            : (isHovered
                  ? AppPalette.primaryColor(context)
                  : AppPalette.reverseAdaptiveColor(context)),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: isHovered ? kSpacing8 : kStroke2,
            offset: Offset(0, isHovered ? kStroke4 : kStroke1),
          ),
        ],
      ),
    );
  }
}

class _BurgerMenuOverlay extends ConsumerWidget {
  const _BurgerMenuOverlay();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    void onMenuItemTap(PortfolioSection section) {
      ref.read(scrollTargetProvider.notifier).state = section;
      Navigator.of(context).pop();
    }

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: AppPalette.darkMode.withOpacity(0.95),
        body: Center(
          child: GestureDetector(
            onTap: () {}, // Prevents taps on the menu from closing the dialog.
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _MenuItem(
                  label: localizations.aboutLabel,
                  onTap: () => onMenuItemTap(PortfolioSection.about),
                ),
                const SizedBox(height: kSpacing30),
                _MenuItem(
                  label: localizations.educationLabel,
                  onTap: () => onMenuItemTap(PortfolioSection.education),
                ),
                const SizedBox(height: kSpacing30),
                _MenuItem(
                  label: localizations.experienceLabel,
                  onTap: () => onMenuItemTap(PortfolioSection.experience),
                ),
                const SizedBox(height: kSpacing30),
                _MenuItem(
                  label: localizations.skillsLabel,
                  onTap: () => onMenuItemTap(PortfolioSection.skills),
                ),
                const SizedBox(height: kSpacing30),
                _MenuItem(
                  label: localizations.contactLabel,
                  onTap: () => onMenuItemTap(PortfolioSection.contact),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _MenuItem({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label.toUpperCase(),
        style: AppTypography.heading3(context, color: AppPalette.lightMode),
      ),
    );
  }
}
