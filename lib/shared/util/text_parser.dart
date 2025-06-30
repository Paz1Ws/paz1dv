import 'package:flutter/material.dart';
import 'package:paz1dv/config/app/app_typography.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';

class TextParser {
  static List<Widget> parseDescriptionWithBullets(
    BuildContext context,
    String description,
  ) {
    final lines = description.split('\n');
    final widgets = <Widget>[];

    for (final line in lines) {
      final trimmedLine = line.trim();

      if (trimmedLine.startsWith('- ')) {
        final bulletText = trimmedLine.substring(2);
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: kSpacing8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6, right: kSpacing8),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppPalette.primaryColor(context),
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    bulletText,
                    style: AppTypography.bulletPoint(
                      context,
                      color: AppPalette.mutedGray,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (trimmedLine.isNotEmpty) {
        // Regular paragraph text
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: kSpacing12),
            child: Text(
              trimmedLine,
              style: AppTypography.bodyMedium(
                context,
                color: AppPalette.mutedGray,
              ),
            ),
          ),
        );
      }
    }

    return widgets;
  }
}
