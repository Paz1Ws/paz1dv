import 'package:flutter/material.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';
import 'package:rive/rive.dart';

class ProfileImageCard extends StatelessWidget {
  final Size size;
  final bool isNarrow;

  const ProfileImageCard({
    super.key,
    required this.size,
    required this.isNarrow,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = isNarrow ? size.width * 0.8 : size.width * 0.35;
    final cardHeight = isNarrow ? size.height * 0.45 : size.height * 0.6;

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Cards de fondo
          BackgroundCard(
            size: size,
            isNarrow: isNarrow,
            cardWidth: cardWidth,
            cardHeight: cardHeight,
          ),
          MiddleCard(
            size: size,
            isNarrow: isNarrow,
            cardWidth: cardWidth,
            cardHeight: cardHeight,
          ),
          MainCard(
            size: size,
            isNarrow: isNarrow,
            cardWidth: cardWidth,
            cardHeight: cardHeight,
          ),

          RiveAnimationOverlay(
            size: size,
            isNarrow: isNarrow,
            cardWidth: cardWidth,
            cardHeight: cardHeight,
          ),

          // Accent decorativo
          AccentDecoration(size: size),
        ],
      ),
    );
  }
}

class BackgroundCard extends StatelessWidget {
  final Size size;
  final bool isNarrow;
  final double cardWidth;
  final double cardHeight;

  const BackgroundCard({
    super.key,
    required this.size,
    required this.isNarrow,
    required this.cardWidth,
    required this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: size.height * 0.06,
      left: -size.width * 0.02,
      child: Transform.rotate(
        angle: -0.2,
        child: Container(
          width: cardWidth * 0.9,
          height: cardHeight * 0.75,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppPalette.primaryColor(context),
                blurRadius: size.width * 0.015,
                offset: Offset(0, size.height * 0.008),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MiddleCard extends StatelessWidget {
  final Size size;
  final bool isNarrow;
  final double cardWidth;
  final double cardHeight;

  const MiddleCard({
    super.key,
    required this.size,
    required this.isNarrow,
    required this.cardWidth,
    required this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: size.height * 0.03,
      left: -size.width * 0.01,
      child: Transform.rotate(
        angle: -0.09,
        child: Container(
          width: cardWidth * 0.95,
          height: cardHeight * 0.8,
          decoration: BoxDecoration(
            color: AppPalette.reverseAdaptiveColor(context),
            borderRadius: BorderRadius.circular(kRadius20),
          ),
        ),
      ),
    );
  }
}

class MainCard extends StatelessWidget {
  final Size size;
  final bool isNarrow;
  final double cardWidth;
  final double cardHeight;

  const MainCard({
    super.key,
    required this.size,
    required this.isNarrow,
    required this.cardWidth,
    required this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          color: AppPalette.darkCharcoal,
          borderRadius: BorderRadius.circular(kRadius20),
          boxShadow: [
            BoxShadow(
              color: AppPalette.darkCharcoal.withOpacity(0.25),
              blurRadius: size.width * 0.025,
              offset: Offset(0, size.height * 0.015),
            ),
          ],
        ),
      ),
    );
  }
}

class RiveAnimationOverlay extends StatelessWidget {
  final Size size;
  final bool isNarrow;
  final double cardWidth;
  final double cardHeight;

  const RiveAnimationOverlay({
    super.key,
    required this.size,
    required this.isNarrow,
    required this.cardWidth,
    required this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -size.height * 0.02,
      left: -size.width * 0.01,
      child: SizedBox(
        width: cardWidth * 1.1, // Más grande que la card principal
        height: cardHeight * 1.1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(kRadius20),
          child: RiveAnimation.asset(
            'assets/images/hard_at_work.riv',
            animations: const ['StatueMove'],
            fit: BoxFit.contain, // Mantiene aspect ratio
            onInit: (artboard) {
              print('Rive animation initialized');
            },
          ),
        ),
      ),
    );
  }
}

class AccentDecoration extends StatelessWidget {
  final Size size;

  const AccentDecoration({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -size.height * 0.01,
      right: -size.width * 0.01,
      child: Container(
        width: size.width * 0.06,
        height: size.width * 0.06,
        decoration: BoxDecoration(
          color: AppPalette.goldenYellow,
          borderRadius: BorderRadius.circular(kRadius100),
          boxShadow: [
            BoxShadow(
              color: AppPalette.goldenYellow.withAlpha(102),
              blurRadius: size.width * 0.015,
              offset: Offset(0, size.height * 0.005),
            ),
          ],
        ),
      ),
    );
  }
}
