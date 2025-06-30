import 'package:flutter/material.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/app/app_typography.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';
import 'package:paz1dv/config/constants/responsive_constants.dart';
import 'package:paz1dv/config/gen/app_localizations.dart';

class EducationCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final String provider; // New parameter
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
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isNarrow = ResponsiveConstants.isNarrowScreen(context);

    return Container(
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
                  title,
                  style: AppTypography.buttonMedium(
                    context,
                    color: AppPalette.darkMode,
                  ),
                ),
                if (!isNarrow)
                  Text(
                    description,
                    maxLines: 2,
                    style: AppTypography.bodySmall(
                      context,
                      color: AppPalette.darkMode.withAlpha(50),
                    ),
                  ),

                if (provider.isNotEmpty)
                  FittedBox(
                    child: Text(
                      '${localizations.forLabel} $provider',
                      style: AppTypography.bodySmallBold(
                        context,
                        color: AppPalette.darkMode,
                      ),
                      maxLines: 2,
                    ),
                  ),
                // --- End new provider text ---
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
            child: Image.network(imagePath, fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}
