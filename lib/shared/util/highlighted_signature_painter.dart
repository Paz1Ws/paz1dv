import 'dart:math';
import 'package:flutter/material.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';

class HighlightedSignaturePainter extends CustomPainter {
  final double pathProgress;
  final double brightness;
  final double signatureFade;
  final double dotHighlight;
  final double dotRotation;
  final Color primaryColor;

  HighlightedSignaturePainter(
    this.pathProgress,
    this.brightness,
    this.signatureFade,
    this.dotHighlight,
    this.dotRotation,
    this.primaryColor,
  );

  Path _createSignaturePath(Size size) {
    final w = size.width;
    final h = size.height;
    final scaleY = 1.25;
    final path = Path();

    // "P" with a hybrid curve
    path.moveTo(w * 0.08, h * 0.85 * scaleY);
    path.cubicTo(
      w * 0.06,
      h * 0.70 * scaleY,
      w * 0.04,
      h * 0.50 * scaleY,
      w * 0.06,
      h * 0.25 * scaleY,
    );
    path.cubicTo(
      w * 0.08,
      h * 0.15 * scaleY,
      w * 0.10,
      h * 0.11 * scaleY,
      w * 0.15,
      h * 0.10 * scaleY,
    );
    path.cubicTo(
      w * 0.22,
      h * 0.08 * scaleY,
      w * 0.28,
      h * 0.14 * scaleY,
      w * 0.31,
      h * 0.22 * scaleY,
    );
    path.cubicTo(
      w * 0.33,
      h * 0.30 * scaleY,
      w * 0.30,
      h * 0.38 * scaleY,
      w * 0.24,
      h * 0.40 * scaleY,
    );
    path.cubicTo(
      w * 0.19,
      h * 0.42 * scaleY,
      w * 0.16,
      h * 0.40 * scaleY,
      w * 0.14,
      h * 0.44 * scaleY,
    );

    // Connection to "a"
    path.cubicTo(
      w * 0.17,
      h * 0.46 * scaleY,
      w * 0.22,
      h * 0.49 * scaleY,
      w * 0.30,
      h * 0.46 * scaleY,
    );

    // "a" loops
    path.cubicTo(
      w * 0.38,
      h * 0.43 * scaleY,
      w * 0.46,
      h * 0.39 * scaleY,
      w * 0.52,
      h * 0.44 * scaleY,
    );
    path.cubicTo(
      w * 0.56,
      h * 0.47 * scaleY,
      w * 0.58,
      h * 0.53 * scaleY,
      w * 0.54,
      h * 0.59 * scaleY,
    );
    path.cubicTo(
      w * 0.50,
      h * 0.63 * scaleY,
      w * 0.44,
      h * 0.61 * scaleY,
      w * 0.40,
      h * 0.56 * scaleY,
    );
    path.cubicTo(
      w * 0.38,
      h * 0.51 * scaleY,
      w * 0.40,
      h * 0.46 * scaleY,
      w * 0.46,
      h * 0.44 * scaleY,
    );

    // "z" with a balanced zigzag
    path.cubicTo(
      w * 0.52,
      h * 0.42 * scaleY,
      w * 0.56,
      h * 0.46 * scaleY,
      w * 0.62,
      h * 0.49 * scaleY,
    );
    path.cubicTo(
      w * 0.68,
      h * 0.52 * scaleY,
      w * 0.75,
      h * 0.50 * scaleY,
      w * 0.80,
      h * 0.47 * scaleY,
    );
    path.cubicTo(
      w * 0.84,
      h * 0.45 * scaleY,
      w * 0.87,
      h * 0.42 * scaleY,
      w * 0.90,
      h * 0.40 * scaleY,
    );
    path.cubicTo(
      w * 0.92,
      h * 0.44 * scaleY,
      w * 0.91,
      h * 0.49 * scaleY,
      w * 0.88,
      h * 0.57 * scaleY,
    );
    path.cubicTo(
      w * 0.84,
      h * 0.66 * scaleY,
      w * 0.78,
      h * 0.73 * scaleY,
      w * 0.72,
      h * 0.76 * scaleY,
    );
    path.cubicTo(
      w * 0.66,
      h * 0.78 * scaleY,
      w * 0.62,
      h * 0.75 * scaleY,
      w * 0.60,
      h * 0.70 * scaleY,
    );
    path.cubicTo(
      w * 0.59,
      h * 0.65 * scaleY,
      w * 0.62,
      h * 0.62 * scaleY,
      w * 0.66,
      h * 0.64 * scaleY,
    );
    path.cubicTo(
      w * 0.72,
      h * 0.66 * scaleY,
      w * 0.76,
      h * 0.71 * scaleY,
      w * 0.78,
      h * 0.76 * scaleY,
    );
    path.cubicTo(
      w * 0.80,
      h * 0.83 * scaleY,
      w * 0.82,
      h * 0.89 * scaleY,
      w * 0.86,
      h * 0.91 * scaleY,
    );
    path.cubicTo(
      w * 0.92,
      h * 0.93 * scaleY,
      w * 0.96,
      h * 0.89 * scaleY,
      w * 0.99,
      h * 0.84 * scaleY,
    );

    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final scaleY = 1.25;
    final path = _createSignaturePath(size);

    // Validate size before painting
    if (w <= 0 || h <= 0) return;

    // Draw soft shadow for base signature
    final softShadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.15)
      ..strokeWidth = kStroke1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.0);

    canvas.translate(1, 1);
    canvas.drawPath(path, softShadowPaint);
    canvas.translate(-1, -1);

    // Always draw the base signature (NEVER DISAPPEARS)
    final mainPaint = Paint()
      ..color = AppPalette.charcoalGray
      ..strokeWidth = kStroke3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, mainPaint);

    // Draw the dot at the end (always visible)
    final dotCenter = Offset(w * 0.97, h * 0.53 * scaleY);

    // Base dot
    final dotPaint = Paint()
      ..color = AppPalette.charcoalGray
      ..style = PaintingStyle.fill;

    final baseDotRadius = (w * 0.015).clamp(1.0, 10.0);
    canvas.drawCircle(dotCenter, baseDotRadius, dotPaint);

    // Highlighted dot when animation ends
    if (dotHighlight > 0) {
      // Subtle highlight background with smooth opacity
      final dotHighlightPaint = Paint()
        ..color = primaryColor.withOpacity(
          (0.2 * dotHighlight).clamp(0.0, 1.0),
        )
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          (2.0 + dotHighlight * 2.0).clamp(1.0, 4.0),
        );

      final highlightRadius = (w * 0.022 * (1.0 + dotHighlight * 0.5)).clamp(
        1.0,
        12.0,
      );
      canvas.drawCircle(dotCenter, highlightRadius, dotHighlightPaint);

      // Gentle white glow with smooth transition
      final dotGlowPaint = Paint()
        ..color = AppPalette.lightMode.withOpacity(
          (0.7 * dotHighlight).clamp(0.0, 1.0),
        )
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          (1.0 + dotHighlight * 1.5).clamp(0.5, 2.5),
        );

      final glowRadius = (w * 0.018 * (1.0 + dotHighlight * 0.3)).clamp(
        1.0,
        10.0,
      );
      canvas.drawCircle(dotCenter, glowRadius, dotGlowPaint);

      // Draw spinning rays
      final rayPaint = Paint()
        ..color = primaryColor.withOpacity(
          (0.7 * dotHighlight).clamp(0.0, 1.0),
        )
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.save();
      canvas.translate(dotCenter.dx, dotCenter.dy);
      canvas.rotate(dotRotation * 2 * pi); // dotRotation is in turns
      canvas.translate(-dotCenter.dx, -dotCenter.dy);

      const rayCount = 4;
      final rayLength = (w * 0.015).clamp(1.5, 5.0);
      const raySpreadAngle = pi / 4; // 45 degrees

      for (int i = 0; i < rayCount; i++) {
        // Angle for top-right quadrant, centered at -pi/4
        final angle =
            -pi / 4 -
            (raySpreadAngle / 2) +
            (i * raySpreadAngle / (rayCount - 1));
        final startPoint =
            dotCenter + Offset.fromDirection(angle, baseDotRadius * 1.5);
        final endPoint =
            dotCenter +
            Offset.fromDirection(
              angle,
              baseDotRadius * 1.5 + rayLength * dotHighlight,
            );
        canvas.drawLine(startPoint, endPoint, rayPaint);
      }

      canvas.restore();
    }

    // Draw highlighter effect ONLY when brightness > 0
    if (brightness > 0 && pathProgress > 0) {
      final pathMetrics = path.computeMetrics();

      for (final metric in pathMetrics) {
        final totalLength = metric.length;
        if (totalLength <= 0) continue;

        final highlightedLength = (totalLength * pathProgress).clamp(
          0.0,
          totalLength,
        );

        if (highlightedLength > 0) {
          // Extract the highlighted portion of the path
          final highlightPath = metric.extractPath(0, highlightedLength);

          // Draw highlighter background
          final highlighterPaint = Paint()
            ..color = primaryColor.withOpacity(
              (0.5 * brightness).clamp(0.0, 1.0),
            )
            ..strokeWidth = 6.0
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round;

          canvas.drawPath(highlightPath, highlighterPaint);

          // Draw subtle shine at the current position (pen tip)
          final currentPos = metric.getTangentForOffset(highlightedLength);
          if (currentPos != null) {
            final shinePaint = Paint()
              ..color = AppPalette.lightMode.withOpacity(
                (0.6 * brightness).clamp(0.0, 1.0),
              )
              ..style = PaintingStyle.fill
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);

            final shineRadius = (kStroke3 * brightness).clamp(1.0, 8.0);
            canvas.drawCircle(currentPos.position, shineRadius, shinePaint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant HighlightedSignaturePainter oldDelegate) =>
      oldDelegate.pathProgress != pathProgress ||
      oldDelegate.brightness != brightness ||
      oldDelegate.signatureFade != signatureFade ||
      oldDelegate.dotHighlight != dotHighlight ||
      oldDelegate.dotRotation != dotRotation ||
      oldDelegate.primaryColor != primaryColor;
}
