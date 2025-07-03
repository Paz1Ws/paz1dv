import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paz1dv/config/app/app_config_providers.dart';
import 'package:paz1dv/config/constants/responsive_constants.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/app/app_icons.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';
import 'package:paz1dv/config/gen/app_localizations.dart';
import 'package:paz1dv/core/services/audio_player_service.dart';
import 'package:paz1dv/features/home/presentation/widgets/music_flyers.dart';

final remixButtonTappedProvider = StateProvider<bool>((ref) => false);

class ActionButtons extends ConsumerWidget {
  final Size size;
  final bool switchValue;

  const ActionButtons({
    super.key,
    required this.size,
    required this.switchValue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNarrowScreen = ResponsiveConstants.isNarrowScreen(context);
    final localizations = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(languageProvider);

    return _ActionButtonsLayout(
      isNarrow: isNarrowScreen,
      size: size,
      ref: ref,
      localizations: localizations,
      currentLocale: currentLocale,
    );
  }
}

class _ActionButtonsLayout extends StatelessWidget {
  final bool isNarrow;
  final Size size;
  final WidgetRef ref;
  final AppLocalizations localizations;
  final Locale currentLocale;

  const _ActionButtonsLayout({
    required this.isNarrow,
    required this.size,
    required this.ref,
    required this.localizations,
    required this.currentLocale,
  });

  @override
  Widget build(BuildContext context) {
    final showFlyers = ref.watch(remixButtonTappedProvider);

    if (isNarrow) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        spacing: kSpacing4,
        children: [
          Row(
            spacing: kSpacing4, // Reducido aún más
            mainAxisSize: MainAxisSize.min,
            children: [
              _ThemeButton(size: size, ref: ref),
              _RemixButton(size: size),
            ],
          ),
          _LanguageToggle(
            size: size,
            ref: ref,
            currentLocale: currentLocale,
            isNarrow: true,
          ),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        spacing: kSpacing4, // Reducido aún más
        children: [
          _ThemeButton(size: size, ref: ref),
          _RemixButton(size: size),
          AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.only(left: showFlyers ? kSpacing12 : 0),
            child: _LanguageToggle(
              size: size,
              ref: ref,
              currentLocale: currentLocale,
              isNarrow: false,
            ),
          ),
        ],
      );
    }
  }
}

class _ThemeButton extends StatefulWidget {
  final Size size;
  final WidgetRef ref;
  bool? isHover = true;
  _ThemeButton({required this.size, required this.ref, this.isHover});

  @override
  State<_ThemeButton> createState() => _ThemeButtonState();
}

class _ThemeButtonState extends State<_ThemeButton> {
  @override
  Widget build(BuildContext context) {
    final themeMode = widget.ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final isNarrow = ResponsiveConstants.isNarrowScreen(context);
    final buttonSize = isNarrow
        ? widget.size.height * 0.05
        : widget.size.height * 0.06;
    final iconSize = isNarrow
        ? widget.size.height * 0.025
        : widget.size.height * 0.03;
    return MouseRegion(
      onHover: (_) {
        setState(() {
          widget.isHover = true;
        });
      },
      onExit: (_) {
        setState(() {
          widget.isHover = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          widget.ref.read(themeModeProvider.notifier).state = isDark
              ? ThemeMode.light
              : ThemeMode.dark;
        },
        child: Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark ? AppPalette.neonLime : AppPalette.vibrantBlue,
           
            boxShadow: widget.isHover == true
                ? [
                    BoxShadow(
                      color: isDark
                          ? AppPalette.electricLime.withAlpha(120)
                          : AppPalette.vibrantBlue.withAlpha(20),
                      blurRadius: 28,
                      spreadRadius: widget.size.width * 0.005,
                      blurStyle: BlurStyle.normal
                    ),
                  ]
                : null,
          ),
          child: Icon(
            isDark ? AppIcons.sun : AppIcons.moon,
            size: iconSize,
            color: AppPalette.adaptiveColor(context),
          ),
        ),
      ),
    );
  }
}

class _RemixButton extends ConsumerWidget {
  final Size size;

  const _RemixButton({required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNarrow = ResponsiveConstants.isNarrowScreen(context);
    final buttonSize = isNarrow ? size.height * 0.05 : size.height * 0.06;
    final iconSize = isNarrow ? size.height * 0.025 : size.height * 0.03;
    final showFlyers = ref.watch(remixButtonTappedProvider);

    return SizedBox(
      width: buttonSize * 2,
      height: buttonSize * 2,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          if (showFlyers) MusicFlyers(iconSize: buttonSize),
          GestureDetector(
            onTap: () {
              final currentState = ref.read(remixButtonTappedProvider);
              if (currentState) {
                ref.read(audioPlayerProvider).stop();
              }
              ref.read(remixButtonTappedProvider.notifier).state =
                  !currentState;
            },
            child: Container(
              width: buttonSize,
              height: buttonSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppPalette.primaryColor(context),
                border: Border.all(
                  color: AppPalette.mutedGray,
                  width: kStroke1,
                ),
              ),
              child: Icon(
                AppIcons.headphones,
                size: iconSize,
                color: AppPalette.darkMode,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageToggle extends StatelessWidget {
  final Size size;
  final WidgetRef ref;
  final Locale currentLocale;
  final bool isNarrow;

  const _LanguageToggle({
    required this.size,
    required this.ref,
    required this.currentLocale,
    required this.isNarrow,
  });

  @override
  Widget build(BuildContext context) {
    final isSpanish = currentLocale.languageCode == 'es';
    final flagAsset = isSpanish
        ? 'assets/images/peruvian.webp'
        : 'assets/images/eeuu.webp';
    final buttonSize = isNarrow ? size.height * 0.05 : size.height * 0.06;

    if (isNarrow) {
      return GestureDetector(
        onTap: () {
          ref.read(languageProvider.notifier).toggleLocale();
        },
        child: Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppPalette.mutedGray, width: kStroke1),
          ),
          child: ClipOval(child: Image.asset(flagAsset, fit: BoxFit.cover)),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          ref.read(languageProvider.notifier).toggleLocale();
        },
        child: Container(
          width: size.width * 0.05,
          height: buttonSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kRadius8),
            border: Border.all(color: AppPalette.mutedGray, width: kStroke1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(kRadius8),
            child: Image.asset(flagAsset, fit: BoxFit.cover),
          ),
        ),
      );
    }
  }
}
