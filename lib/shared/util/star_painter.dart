import 'dart:ui';

import 'package:flutter/material.dart';

class StarPainter extends CustomPainter {
  final Color primaryColor;

  StarPainter(this.primaryColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final outerRadius = size.width / 1.5;
    final innerRadius = size.width / 4;

    // Create four-pointed star
    path.moveTo(centerX, centerY - outerRadius); // Top point
    path.lineTo(centerX + innerRadius, centerY - innerRadius);
    path.lineTo(centerX + outerRadius, centerY); // Right point
    path.lineTo(centerX + innerRadius, centerY + innerRadius);
    path.lineTo(centerX, centerY + outerRadius); // Bottom point
    path.lineTo(centerX - innerRadius, centerY + innerRadius);
    path.lineTo(centerX - outerRadius, centerY); // Left point
    path.lineTo(centerX - innerRadius, centerY - innerRadius);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
