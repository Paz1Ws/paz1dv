import 'package:flutter/material.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/app/app_typography.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';

class DetailItem extends StatelessWidget {
  final String title;
  final String value;

  const DetailItem({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.labelSmall(context, color: AppPalette.mutedGray),
        ),
        const SizedBox(height: kSpacing4),
        Text(
          value,
          style: AppTypography.bodyMedium(
            context,
            color: AppPalette.reverseAdaptiveColor(context),
          ),
        ),
      ],
    );
  }
}
