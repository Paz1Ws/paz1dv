import 'package:animate_do/animate_do.dart';
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
              // Background text con animación progresiva por letras
              _buildProgressiveText(context, profileTitle, isNarrow, size),

              // Interactive profile icon con animación flotante sutil
              TweenAnimationBuilder<double>(
                duration: const Duration(seconds: 3),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 4 * (1 - value).abs()),
                    child: child,
                  );
                },
                child: AnimatedContainer(
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
                      boxShadow: [
                        BoxShadow(
                          color: AppPalette.primaryColor(context).withAlpha(51),
                          blurRadius: isInteracting ? 15 : 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressiveText(
    BuildContext context,
    String text,
    bool isNarrow,
    Size size,
  ) {
    // Dividir por líneas primero para respetar los \n
    final lines = text.split('\n');
    int characterIndex = 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: lines.map((line) {
        final lineCharacters = line.split('');
        
        final lineWidget = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: lineCharacters.map((char) {
            final delay = Duration(milliseconds: 400 + (characterIndex * 100));
            characterIndex++; // Incrementar para mantener secuencia global
            
            return FadeInDown(
              duration: const Duration(milliseconds: 600),
              delay: delay,
              curve: Curves.easeOutCubic,
              child: Text(
                char,
                style: AppTypography.heading1(
                  context,
                  color: AppPalette.primaryColor(context),
                ).copyWith(
                  fontSize: isNarrow ? size.width * 0.25 : size.width * 0.15,
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                ),
              ),
            );
          }).toList(),
        );
        
        return lineWidget;
      }).toList(),
    );
  }
}
