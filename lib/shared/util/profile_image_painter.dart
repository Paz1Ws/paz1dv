import 'package:flutter/material.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';

class ProfileImagePainter extends CustomPainter {
  final Color primaryColor;

  ProfileImagePainter(this.primaryColor);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Create neon signature path - stylized "PAZ" signature
    final path = Path();
    path.moveTo(w * 0.2, h * 0.3);
    path.cubicTo(w * 0.25, h * 0.15, w * 0.4, h * 0.2, w * 0.5, h * 0.25);
    path.cubicTo(w * 0.6, h * 0.3, w * 0.75, h * 0.2, w * 0.8, h * 0.4);
    path.cubicTo(w * 0.75, h * 0.5, w * 0.6, h * 0.45, w * 0.4, h * 0.5);

    // Main signature stroke
    final signaturePaint = Paint()
      ..color = primaryColor
      ..strokeWidth = kStroke4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, signaturePaint);

    // Glow effect
    final glowPaint = Paint()
      ..color = primaryColor.withOpacity(0.4)
      ..strokeWidth = kStroke5 * 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6.0);

    canvas.drawPath(path, glowPaint);

    // Outer glow
    final outerGlowPaint = Paint()
      ..color = primaryColor.withOpacity(0.2)
      ..strokeWidth = kStroke5 * 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12.0);

    canvas.drawPath(path, outerGlowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
