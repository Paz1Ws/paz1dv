import 'package:animate_do/animate_do.dart';
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
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: kSpacing8,
        children: [
          showFlyers == true
              ? FadeInRight(
                  child: MusicFlyers(
                    iconSize: size.height * 0.05,
                    isNarrow: true,
                  ),
                )
              : SizedBox.shrink(),
          Column(
            spacing: kSpacing8,
            children: [
              _ThemeButton(size: size, ref: ref),
              _RemixButton(size: size, ref: ref),
              _LanguageToggle(
                size: size,
                ref: ref,
                currentLocale: currentLocale,
                isNarrow: true,
              ),
            ],
          ),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        spacing: kSpacing4,
        children: [
          _ThemeButton(size: size, ref: ref),
          _RemixButtonWithFlyers(size: size, ref: ref),
          AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.only(left: showFlyers ? size.width * 0.001 : 0),
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

class _RemixButtonWithFlyers extends StatelessWidget {
  final Size size;
  final WidgetRef ref;

  const _RemixButtonWithFlyers({required this.size, required this.ref});

  @override
  Widget build(BuildContext context) {
    final showFlyers = ref.watch(remixButtonTappedProvider);
    final buttonSize = size.height * 0.06;

    return SizedBox(
      width: showFlyers ? buttonSize * 3 : buttonSize,
      height: showFlyers ? buttonSize * 3 : buttonSize,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Flyers detrás del botón (solo cuando están activos)
          if (showFlyers)
            Positioned.fill(child: MusicFlyers(iconSize: buttonSize)),
          // Botón de remix siempre en el centro
          Positioned(
            child: _RemixButton(size: size, ref: ref),
          ),
        ],
      ),
    );
  }
}

class _RemixButton extends StatelessWidget {
  final Size size;
  final WidgetRef ref;

  const _RemixButton({required this.size, required this.ref});

  @override
  Widget build(BuildContext context) {
    final isNarrow = ResponsiveConstants.isNarrowScreen(context);
    final buttonSize = isNarrow ? size.height * 0.05 : size.height * 0.06;
    final iconSize = isNarrow ? size.height * 0.025 : size.height * 0.03;
    final showFlyers = ref.watch(remixButtonTappedProvider);
    final audioState = ref.watch(audioStateProvider);

    return HoverableButton(
      onTap: () {
        final currentState = ref.read(remixButtonTappedProvider);
        if (currentState) {
          if (audioState.currentBand != null) {
            ref.read(audioPlayerProvider).stop();
            ref.read(audioStateProvider.notifier).stopPlaying();
          }
          ref.read(remixButtonTappedProvider.notifier).state = false;
        } else {
          ref.read(remixButtonTappedProvider.notifier).state = true;
        }
      },
      shadowColor: AppPalette.primaryColor(context),
      size: size,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: (showFlyers || audioState.currentBand != null)
              ? AppPalette.primaryColor(context)
              : AppPalette.charcoalGray,
          border: Border.all(color: AppPalette.mutedGray, width: kStroke1),
        ),
        child: Icon(
          AppIcons.headphones,
          size: iconSize,
          color: AppPalette.darkMode,
        ),
      ),
    );
  }
}

class HoverableButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color shadowColor;
  final Size size;

  const HoverableButton({
    super.key,
    required this.child,
    required this.onTap,
    required this.shadowColor,
    required this.size,
  });

  @override
  State<HoverableButton> createState() => _HoverableButtonState();
}

class _HoverableButtonState extends State<HoverableButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _pulseController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _pulseController.reverse();
      },
      child: GestureDetector(
        onTap: () {
          _pulseController.reverse().then((_) {
            _pulseController.forward();
          });
          widget.onTap();
        },
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + (_pulseController.value * 0.05),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: widget.shadowColor.withAlpha(120),
                            blurRadius: 28,
                            spreadRadius: widget.size.width * 0.005,
                            blurStyle: BlurStyle.normal,
                          ),
                        ]
                      : null,
                ),
                child: widget.child,
              ),
            );
          },
        ),
      ),
    );
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

    return HoverableButton(
      onTap: () {
        ref.read(themeModeProvider.notifier).state = isDark
            ? ThemeMode.light
            : ThemeMode.dark;
      },
      shadowColor: isDark ? AppPalette.electricLime : AppPalette.vibrantBlue,
      size: size,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? AppPalette.neonLime : AppPalette.vibrantBlue,
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
        ? 'assets/images/eeuu.webp'
        : 'assets/images/peruvian.webp';
    final buttonSize = isNarrow ? size.height * 0.05 : size.height * 0.06;

    return HoverableButton(
      onTap: () {
        ref.read(languageProvider.notifier).toggleLocale();
      },
      shadowColor: AppPalette.mutedGray,
      size: size,
      child: Container(
        width: isNarrow ? buttonSize : size.width * 0.05,
        height: buttonSize,
        decoration: BoxDecoration(
          shape: isNarrow ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isNarrow ? null : BorderRadius.circular(kRadius8),
          border: Border.all(color: AppPalette.mutedGray, width: kStroke1),
        ),
        child: isNarrow
            ? ClipOval(child: Image.asset(flagAsset, fit: BoxFit.cover))
            : ClipRRect(
                borderRadius: BorderRadius.circular(kRadius8),
                child: Image.asset(flagAsset, fit: BoxFit.cover),
              ),
      ),
    );
  }
}
