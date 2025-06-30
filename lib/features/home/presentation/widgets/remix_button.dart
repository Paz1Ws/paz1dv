import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:paz1dv/config/constants/responsive_constants.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/app/app_typography.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';
import 'package:paz1dv/config/gen/app_localizations.dart';
import 'package:paz1dv/features/home/presentation/widgets/burger_menu_button.dart';
import 'package:paz1dv/features/home/presentation/widgets/animated_signature.dart';

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
