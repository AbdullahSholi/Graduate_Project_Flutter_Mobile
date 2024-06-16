import 'package:flutter/material.dart';

class DiscountPainter extends CustomPainter {
  final double discountPercentage;

  DiscountPainter(this.discountPercentage);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    // Draw the background circle
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2;
    canvas.drawCircle(center, radius, paint);

    // Draw the percentage text
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: '-${discountPercentage.toInt()}%',
        style: TextStyle(
          color: Colors.white,
          fontSize: radius / 1.5,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    final Offset textOffset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    );

    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
