import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paz1dv/config/constants/responsive_constants.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/app/app_typography.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';

final containerOffsetProvider = StateProvider<Offset>((ref) => Offset.zero);
final isInteractingProvider = StateProvider<bool>((ref) => false);

class InteractiveProfileContainer extends ConsumerWidget {
  final String photoUrl;
  final String profileTitle;
  const InteractiveProfileContainer({
    super.key,
    required this.photoUrl,
    required this.profileTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final isNarrow = ResponsiveConstants.isNarrowScreen(context);
    final containerOffset = ref.watch(containerOffsetProvider);
    final isInteracting = ref.watch(isInteractingProvider);

    return SizedBox(
      width: isNarrow ? size.width : size.width * 0.6,
      child: MouseRegion(
        onHover: (event) {
          if (!isNarrow) {
            final localPosition = event.localPosition;
            final center = Offset(size.width * 0.3, size.height * 0.15);
            final offset = (localPosition - center) * 0.1;

            ref.read(containerOffsetProvider.notifier).state = offset;
            ref.read(isInteractingProvider.notifier).state = true;
          }
        },
        onExit: (_) {
          ref.read(containerOffsetProvider.notifier).state = Offset.zero;
          ref.read(isInteractingProvider.notifier).state = false;
        },
        child: GestureDetector(
          onPanUpdate: (details) {
            if (isNarrow) {
              final center = Offset(size.width * 0.45, size.height * 0.2);
              final offset = (details.localPosition - center) * 0.05;

              ref.read(containerOffsetProvider.notifier).state = offset;
              ref.read(isInteractingProvider.notifier).state = true;
            }
          },
          onPanEnd: (_) {
            ref.read(containerOffsetProvider.notifier).state = Offset.zero;
            ref.read(isInteractingProvider.notifier).state = false;
          },
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Background text
              Text(
                profileTitle,
                style:
                    AppTypography.heading1(
                      context,
                      color: AppPalette.primaryColor(context),
                    ).copyWith(
                      fontSize: isNarrow
                          ? size.width * 0.25
                          : size.width * 0.15,
                      fontWeight: FontWeight.w900,
                    ),
                textAlign: TextAlign.center,
              ),

              // Interactive profile icon
              AnimatedContainer(
                duration: Duration(milliseconds: isInteracting ? 100 : 800),
                curve: isInteracting ? Curves.easeOut : Curves.elasticOut,
                transform: Matrix4.translationValues(
                  containerOffset.dx,
                  containerOffset.dy,
                  0,
                ),
                child: Container(
                  width: isNarrow ? size.width * 0.35 : size.width * 0.11,
                  height: isNarrow ? size.width * 0.35 : size.width * 0.22,
                  decoration: BoxDecoration(
                    color: AppPalette.charcoalGray,
                    shape: isNarrow ? BoxShape.circle : BoxShape.rectangle,
                    border: Border.all(
                      color: AppPalette.mutedGray,
                      width: kStroke2,
                    ),
                    borderRadius: isNarrow ? null : BorderRadius.circular(64),
                    image: isNarrow
                        ? null
                        : DecorationImage(
                            image: AssetImage(photoUrl),
                            fit: BoxFit.cover,
                          ),
                  ),
                  child: isNarrow
                      ? ClipOval(
                          child: OverflowBox(
                            maxWidth: size.width * 0.35,
                            maxHeight: size.width * 0.35,
                            child: Image.asset(photoUrl, fit: BoxFit.cover),
                          ),
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
