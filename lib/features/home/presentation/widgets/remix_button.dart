import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:paz1dv/config/constants/responsive_constants.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';
import 'package:paz1dv/config/gen/app_localizations.dart';

class RemixButton extends StatelessWidget {
  final Size size;
  final AppLocalizations localizations;
  const RemixButton({
    super.key,
    required this.size,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    final mobile = ResponsiveConstants.isMobile(context);
    return Container(
      width: mobile ? size.width * 0.2 : size.width * 0.03,
      height: mobile ? size.width * 0.05 : size.width * 0.03,
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.01,
        vertical: size.height * 0.01,
      ),
      decoration: BoxDecoration(
        border: Border.all(width: kStroke1, color: AppPalette.mutedGray),
        borderRadius: BorderRadius.circular(kRadius40),
        color: AppPalette.primaryColor(context),
      ),
      child: Center(child: Icon(HugeIcons.strokeRoundedEar)),
    );
  }
}
