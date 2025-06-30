import 'package:flutter/material.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/app/app_typography.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';
import 'package:paz1dv/config/constants/responsive_constants.dart';
import 'package:paz1dv/config/gen/app_localizations.dart';

class ScrollIndicator extends StatefulWidget {
  const ScrollIndicator({super.key});

  @override
  State<ScrollIndicator> createState() => _ScrollIndicatorState();
}

class _ScrollIndicatorState extends State<ScrollIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.1, end: 0.9).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.repeat(reverse: true);
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
    final localizations = AppLocalizations.of(context)!;
    return Column(
      spacing: size.height * 0.02,
      children: [
        Container(
          width: isNarrow ? 2.0 : 3.0,
          height: isNarrow ? size.height * 0.05 : size.height * 0.8,
          constraints: BoxConstraints(maxHeight: 50),
          decoration: BoxDecoration(
            color: AppPalette.mutedGray.withAlpha(75),
            borderRadius: BorderRadius.circular(kPadding12),
          ),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Align(
                alignment: Alignment(0, (_animation.value * 2) - 1),
                child: Container(
                  width: isNarrow ? 2.0 : 3.0,
                  height: isNarrow ? size.height * 0.02 : size.height * 0.025,
                  decoration: BoxDecoration(
                    color: AppPalette.primaryColor(context),
                    borderRadius: BorderRadius.circular(kPadding12),
                  ),
                ),
              );
            },
          ),
        ),

        Text(
          localizations.scrollText,
          style: AppTypography.overline(
            context,
            color: AppPalette.charcoalGray,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
