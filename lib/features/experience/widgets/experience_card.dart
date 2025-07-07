import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/app/app_typography.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';
import 'package:paz1dv/config/gen/app_localizations.dart';
import 'package:paz1dv/features/experience/domain/experience_model.dart';

class ExperienceCard extends StatefulWidget {
  final ExperienceModel item;
  final VoidCallback onTap;
  final Size size;

  const ExperienceCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.size,
  });

  @override
  State<ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<ExperienceCard>
    with TickerProviderStateMixin {
  bool isHovered = false;
  late AnimationController _scaleController;
  late AnimationController _indicatorController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _indicatorSlideAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _indicatorController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInCirc),
    );

    _indicatorSlideAnimation =
        Tween<Offset>(begin: const Offset(-1.5, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _indicatorController,
            curve: Curves.easeOutCubic,
          ),
        );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _indicatorController.dispose();
    super.dispose();
  }

  void _onHover(bool hovering) {
    setState(() {
      isHovered = hovering;
    });

    if (hovering) {
      _scaleController.forward();
      _indicatorController.forward();
    } else {
      _scaleController.reverse();
      _indicatorController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Image.network(
                    widget.item.backgroundImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: AppPalette.darkCharcoal);
                    },
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppPalette.darkMode.withAlpha(150),
                    AppPalette.darkMode.withAlpha(210),
                  ],
                ),
              ),
            ),
            Center(
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: kSpacing8,
                      children: [
                        Image.network(
                          widget.item.icon,
                          width: widget.size.width * 0.1,
                          height: widget.size.width * 0.1,
                          color: AppPalette.lightMode,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(
                              widget.item.icon,
                              color: AppPalette.lightMode,
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kPadding18,
                          ),
                          child: Text(
                            widget.item.title,
                            style: AppTypography.subtitleLarge(
                              context,
                            ).copyWith(color: AppPalette.lightMode),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: SlideTransition(
                position: _indicatorSlideAnimation,
                child: AnimatedOpacity(
                  opacity: isHovered ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kSpacing12,
                      vertical: kSpacing8,
                    ),
                    decoration: BoxDecoration(
                      color: AppPalette.primaryColor(context),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(kRadius12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: kSpacing4,
                      children: [
                        const Icon(
                          HugeIcons.strokeRoundedArrowRight05,
                          color: AppPalette.darkMode,
                          size: kIconSize16,
                        ),
                        Text(
                          localizations.knowMore,
                          style: AppTypography.bodySmall(
                            context,
                            color: AppPalette.darkMode,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isHovered
                      ? AppPalette.primaryColor(context)
                      : AppPalette.adaptiveColor(context),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(kRadius12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
