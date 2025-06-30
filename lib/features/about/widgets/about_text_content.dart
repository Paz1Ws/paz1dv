import 'package:flutter/material.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/app/app_icons.dart';
import 'package:paz1dv/config/config.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';
import 'package:paz1dv/config/gen/app_localizations.dart';
import 'package:paz1dv/config/app/app_typography.dart';

class AboutTextContent extends StatelessWidget {
  final Size size;
  final bool isNarrow;
  final String aboutPassion;
  final String aboutDetails;

  const AboutTextContent({
    super.key,
    required this.size,
    required this.isNarrow,
    required this.aboutPassion,
    required this.aboutDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isNarrow ? 20 : 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
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
          ),
          const SizedBox(height: 24),
          Text(
            aboutDetails,
            style: AppTypography.bodyLarge(
              context,
              color: AppPalette.mutedGray,
            ),
          ),
        ],
      ),
    );
  }
}
