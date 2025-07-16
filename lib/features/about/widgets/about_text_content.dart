import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';
import 'package:paz1dv/config/app/app_typography.dart';
import 'package:paz1dv/config/constants/responsive_constants.dart';
import 'package:paz1dv/config/gen/app_localizations.dart';
import 'package:paz1dv/shared/util/url_launcher_util.dart';
import 'package:paz1dv/config/app/app_icons.dart';

class AboutTextContent extends StatelessWidget {
  final Size size;
  final bool isNarrow;
  final String aboutPassion;
  final String aboutDetails;
  final bool animate;

  const AboutTextContent({
    super.key,
    required this.size,
    required this.isNarrow,
    required this.aboutPassion,
    required this.aboutDetails,
    this.animate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isNarrow ? size.width * 0.05 : size.width * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: size.height * 0.024,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isNarrow) ...[
            animate
                ? FadeInLeft(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 400),
                    child: SocialMediaSection(size: size),
                  )
                : SocialMediaSection(size: size),
          ],

          // About Passion text with animation
          animate
              ? FadeIn(
                  duration: const Duration(milliseconds: 800),
                  delay: const Duration(milliseconds: 300),
                  child: AboutPassionText(
                    size: size,
                    isNarrow: isNarrow,
                    aboutPassion: aboutPassion,
                  ),
                )
              : AboutPassionText(
                  size: size,
                  isNarrow: isNarrow,
                  aboutPassion: aboutPassion,
                ),

          // About Details text with animation
          animate
              ? FadeIn(
                  duration: const Duration(milliseconds: 800),
                  delay: const Duration(milliseconds: 600),
                  child: AboutDetailsText(
                    size: size,
                    aboutDetails: aboutDetails,
                  ),
                )
              : AboutDetailsText(size: size, aboutDetails: aboutDetails),

          if (!isNarrow) ...[
            SizedBox(height: size.height * 0.01),
            animate
                ? FadeInUp(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 800),
                    child: SocialMediaSection(size: size),
                  )
                : SocialMediaSection(size: size),
          ],
        ],
      ),
    );
  }
}

class AboutPassionText extends StatelessWidget {
  final Size size;
  final bool isNarrow;
  final String aboutPassion;

  const AboutPassionText({
    super.key,
    required this.size,
    required this.isNarrow,
    required this.aboutPassion,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      aboutPassion,
      style: isNarrow
          ? AppTypography.bodyLarge(
              context,
              color: AppPalette.reverseAdaptiveColor(context),
            )
          : AppTypography.heading6(
              context,
              color: AppPalette.reverseAdaptiveColor(context),
            ).copyWith(fontWeight: FontWeight.w400, height: 1.5),
    );
  }
}

class AboutDetailsText extends StatelessWidget {
  final Size size;
  final String aboutDetails;

  const AboutDetailsText({
    super.key,
    required this.size,
    required this.aboutDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      aboutDetails,
      style: AppTypography.bodyLarge(context, color: AppPalette.charcoalGray),
    );
  }
}

class SocialMediaSection extends StatelessWidget {
  final Size size;

  const SocialMediaSection({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      spacing: size.height * 0.02,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.connectWithMe,
          style: AppTypography.subtitleLarge(
            context,
            color: AppPalette.primaryColor(context),
          ),
        ),
        SocialMediaButtons(size: size),
      ],
    );
  }
}

class SocialMediaButtons extends StatelessWidget {
  final Size size;

  const SocialMediaButtons({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Wrap(
        spacing: size.width * 0.02,
        runSpacing: size.height * 0.010,
        children: [
          SocialMediaButton(
            iconData: AppIcons.instagram,
            label: 'Instagram',
            color: AppPalette.rosePink,
            onTap: UrlLauncherUtil.launchInstagram,
          ),
          SocialMediaButton(
            iconData: AppIcons.figma,
            label: 'Figma',
            color: AppPalette.neonLime,
            onTap: UrlLauncherUtil.launchFigma,
          ),
          SocialMediaButton(
            iconData: AppIcons.github,
            label: 'GitHub',
            color: AppPalette.charcoalGray,
            onTap: UrlLauncherUtil.launchGitHub,
          ),
          SocialMediaButton(
            iconData: AppIcons.linkedin,
            label: 'LinkedIn',
            color: AppPalette.vibrantBlue,
            onTap: UrlLauncherUtil.launchLinkedIn,
          ),
        ],
      ),
    );
  }
}

class SocialMediaButton extends StatefulWidget {
  final IconData iconData;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const SocialMediaButton({
    super.key,
    required this.iconData,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<SocialMediaButton> createState() => _SocialMediaButtonState();
}

class _SocialMediaButtonState extends State<SocialMediaButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isNarrow = ResponsiveConstants.isNarrowScreen(context);

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _animationController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Material(
              color: AppPalette.adaptiveColor(
                context,
                dark: AppPalette.darkMode,
              ),
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(kRadius20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.02,
                    vertical: size.height * 0.016,
                  ),
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? widget.color.withAlpha(25)
                        : AppPalette.adaptiveColor(
                            context,
                            light: AppPalette.lightGray,
                            dark: AppPalette.darkCharcoal,
                          ),
                    borderRadius: BorderRadius.circular(kRadius20),
                    border: Border.all(
                      color: _isHovered
                          ? widget.color
                          : AppPalette.mutedGray.withAlpha(77),
                      width: _isHovered ? 2 : 1,
                    ),
                    boxShadow: _isHovered
                        ? [
                            BoxShadow(
                              color: widget.color.withAlpha(51),
                              blurRadius: size.width * 0.012,
                              offset: Offset(0, size.height * 0.004),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.iconData,
                        color: _isHovered
                            ? widget.color
                            : AppPalette.reverseAdaptiveColor(context),
                        size: isNarrow ? size.width * 1.1 : size.width * 0.025,
                      ),
                      if (!isNarrow) ...[
                        SizedBox(width: size.width * 0.008),
                        Text(
                          widget.label,
                          style: AppTypography.buttonLarge(
                            context,
                            color: _isHovered
                                ? widget.color
                                : AppPalette.reverseAdaptiveColor(context),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
