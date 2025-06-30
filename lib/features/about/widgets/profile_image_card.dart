import 'package:flutter/material.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/app/app_icons.dart';
import 'package:paz1dv/config/config.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';
import 'package:paz1dv/config/gen/app_localizations.dart';
import 'package:paz1dv/features/about/widgets/about_text_content.dart';
import 'package:paz1dv/shared/util/url_launcher_util.dart';

class ProfileImageCard extends StatelessWidget {
  final Size size;
  final bool isNarrow;

  const ProfileImageCard({
    super.key,
    required this.size,
    required this.isNarrow,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = isNarrow ? size.width / 1.2 : size.width * 0.3;
    final cardHeight = isNarrow ? size.height * 0.5 : size.height * 0.65;

    return Column(
      children: [
        SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 90,
                left: 25,
                child: Container(
                  width: cardWidth,
                  height: cardHeight - 50,
                  decoration: BoxDecoration(
                    color: AppPalette.primaryColor(context),
                    borderRadius: BorderRadius.circular(kRadius20),
                  ),
                ),
              ),

              // Main charcoal container with image
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: cardWidth,
                  height: cardHeight,
                  decoration: BoxDecoration(
                    color: AppPalette.charcoalGray,
                    borderRadius: BorderRadius.circular(kRadius20),
                  ),
                  child: Positioned.fill(
                    right: 20,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(kRadius20),
                      child: Image.asset(
                        'assets/images/eeuu.webp',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              // Social media buttons positioned independently
              Positioned(
                left: 25,
                right: -25,
                bottom: -30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SocialMediaButton(
                      icon: AppIcons.instagram,
                      onTap: UrlLauncherUtil.launchInstagram,
                    ),
                    SocialMediaButton(
                      icon: AppIcons.figma,
                      onTap: UrlLauncherUtil.launchFigma,
                    ),
                    SocialMediaButton(
                      icon: AppIcons.github,
                      onTap: UrlLauncherUtil.launchGitHub,
                    ),
                    SocialMediaButton(
                      icon: AppIcons.linkedin,
                      onTap: UrlLauncherUtil.launchLinkedIn,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SocialMediaButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const SocialMediaButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: AppPalette.darkMode, size: kIconSize24),
    );
  }
}
