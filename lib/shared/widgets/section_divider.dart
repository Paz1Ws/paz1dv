import 'package:flutter/material.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/app/app_typography.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';
import 'package:paz1dv/config/constants/responsive_constants.dart';

class SectionDivider extends StatelessWidget {
  final String title;

  const SectionDivider({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isNarrow = ResponsiveConstants.isNarrowScreen(context);
    return Container(
      color: AppPalette.adaptiveColor(context),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: isNarrow ? size.height * 0.05 : size.height * 0.03,
        ),
        child: Row(
          spacing: kSpacing20,
          children: [
            Text(
              title,
              style: AppTypography.heading4(
                context,
                color: AppPalette.primaryColor(context),
              ).copyWith(fontWeight: FontWeight.w900),
            ),
            Expanded(
              child: Container(
                height: size.height * 0.005,

                color: AppPalette.charcoalGray,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: size.height * 0.005,
                    width: size.width * 0.05,
                    color: AppPalette.goldenYellow,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
