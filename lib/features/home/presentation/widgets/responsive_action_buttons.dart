import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paz1dv/config/app/app_config_providers.dart';
import 'package:paz1dv/config/constants/responsive_constants.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/app/app_typography.dart';
import 'package:paz1dv/config/app/app_icons.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';
import 'package:paz1dv/config/gen/app_localizations.dart';

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
    if (isNarrow) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        spacing: kSpacing8,
        children: [
          Row(
            spacing: kSpacing12,
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
        spacing: kSpacing12,
        children: [
          _ThemeButton(size: size, ref: ref),
          _RemixButton(size: size),
          _LanguageToggle(
            size: size,
            ref: ref,
            currentLocale: currentLocale,
            isNarrow: false,
          ),
        ],
      );
    }
  }
}

class _ThemeButton extends StatelessWidget {
  final Size size;
  final WidgetRef ref;

  const _ThemeButton({required this.size, required this.ref});

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final isNarrow = ResponsiveConstants.isNarrowScreen(context);
    final buttonSize = isNarrow ? size.height * 0.05 : size.height * 0.06;
    final iconSize = isNarrow ? size.height * 0.025 : size.height * 0.03;
    return GestureDetector(
      onTap: () {
        ref.read(themeModeProvider.notifier).state = isDark
            ? ThemeMode.light
            : ThemeMode.dark;
      },
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? AppPalette.neonLime : AppPalette.vibrantBlue,
          border: Border.all(
            color: isDark ? AppPalette.electricLime : AppPalette.vibrantBlue.withOpacity(0.7),
            width: kStroke1,
          ),
        ),
        child: Icon(
          isDark ? AppIcons.sun : AppIcons.moon,
          size: iconSize,
          color: AppPalette.adaptiveColor(context),
        ),
      ),
    );
  }
}

class _RemixButton extends StatelessWidget {
  final Size size;

  const _RemixButton({required this.size});

  @override
  Widget build(BuildContext context) {
    final isNarrow = ResponsiveConstants.isNarrowScreen(context);
    final buttonSize = isNarrow ? size.height * 0.05 : size.height * 0.06;
    final iconSize = isNarrow ? size.height * 0.025 : size.height * 0.03;
    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppPalette.primaryColor(context),
        border: Border.all(color: AppPalette.mutedGray, width: kStroke1),
      ),
      child: Icon(
        AppIcons.headphones,
        size: iconSize,
        color: AppPalette.darkMode,
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
