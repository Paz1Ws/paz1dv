import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paz1dv/config/app/app_icons.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/constants/responsive_constants.dart';

class ScrollToTopButton extends ConsumerWidget {
  final Function onTap;
  const ScrollToTopButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final isNarrow = ResponsiveConstants.isNarrowScreen(context);
    final buttonSize = isNarrow ? size.width * 0.12 : size.width * 0.03;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            color: AppPalette.adaptiveColor(context),
            shape: BoxShape.circle,
            border: Border.all(color: AppPalette.mutedGray, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppPalette.darkMode.withAlpha(120),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            AppIcons.up,
            size: buttonSize * 0.5,
            color: AppPalette.primaryColor(context),
          ),
        ),
      ),
    );
  }
}
