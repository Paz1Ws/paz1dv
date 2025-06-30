import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:paz1dv/config/config.dart';
import 'package:paz1dv/features/home/presentation/widgets/scroll_indicator.dart';

class ShortResumeStatement extends StatelessWidget {
  const ShortResumeStatement({
    super.key,
    required this.size,
    required this.mobile,
  });

  final Size size;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      spacing: size.height * 0.05,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: mobile ? size.width * 0.1 : size.width * 0.2,
          ),
          child: Text(
            localizations.profileDescription,
            style: AppTypography.bodyMedium(
              context,
              color: AppPalette.reverseAdaptiveColor(context),
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const ScrollIndicator(),
      ],
    );
  }
}
