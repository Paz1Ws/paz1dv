import 'package:flutter/material.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/app/app_typography.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';
import 'package:paz1dv/config/constants/responsive_constants.dart';
import 'package:paz1dv/config/gen/app_localizations.dart';

class EducationCard extends StatefulWidget {
  final String title;
  final String description;
  final String imagePath;
  final String provider;
  final Size size;
  const EducationCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.provider,
    required this.size,
  });

  @override
  State<EducationCard> createState() => _EducationCardState();
}

class _EducationCardState extends State<EducationCard>
    with SingleTickerProviderStateMixin {
  bool isHovered = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInCirc),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onHover(bool hovering) {
    setState(() {
      isHovered = hovering;
    });
    if (hovering) {
      _scaleController.forward();
    } else {
      _scaleController.reverse();
    }
  }

  void _showCertificateModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: InteractiveViewer(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(widget.imagePath, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isNarrow = ResponsiveConstants.isNarrowScreen(context);

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: () => _showCertificateModal(context),
        child: Container(
          padding: const EdgeInsets.all(kPadding12),
          decoration: BoxDecoration(
            color: AppPalette.primaryColor(context),
            borderRadius: BorderRadius.circular(kRadius12),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: kSpacing4,
                  children: [
                    Text(
                      widget.title,
                      style: AppTypography.labelLarge(
                        context,
                        color: AppPalette.darkMode,
                      ).copyWith(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!isNarrow)
                      Text(
                        widget.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall(
                          context,
                          color: AppPalette.adaptiveColor(context),
                        ),
                      ),
                    if (widget.provider.isNotEmpty)
                      FittedBox(
                        child: Text(
                          '${localizations.forLabel} ${widget.provider}',
                          style: AppTypography.bodySmallBold(
                            context,
                            color: AppPalette.darkMode,
                          ),
                          maxLines: 2,
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPadding12),
                child: Container(
                  width: 1,
                  height: 50,
                  color: AppPalette.darkMode.withAlpha(50),
                ),
              ),
              Expanded(
                flex: 3,
                child: AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.imagePath,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
