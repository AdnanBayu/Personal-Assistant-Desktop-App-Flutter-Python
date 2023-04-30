import 'dart:math' as math;
import 'package:flutter/material.dart';

class BatteryPercentageBar extends StatelessWidget {
  final double percentage;
  final double size;
  final double strokeWidth;
  final Color backgroundColor;
  final Color foregroundColor;

  const BatteryPercentageBar({
    Key? key,
    required this.percentage,
    this.size = 100,
    this.strokeWidth = 10,
    this.backgroundColor = Colors.grey,
    this.foregroundColor = Colors.blueGrey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _BatteryPainter(
        percentage: percentage,
        strokeWidth: strokeWidth,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
    );
  }
}

class _BatteryPainter extends CustomPainter {
  final double percentage;
  final double strokeWidth;
  final Color backgroundColor;
  final Color foregroundColor;

  _BatteryPainter({
    required this.percentage,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(radius, radius);

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius - strokeWidth / 2, backgroundPaint);

    // Draw foreground arc
    final foregroundPaint = Paint()
      ..color = foregroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    final startAngle = -math.pi / 2;
    final endAngle = startAngle + percentage * 2 * math.pi / 100;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      startAngle,
      endAngle - startAngle,
      false,
      foregroundPaint,
    );

    // Draw percentage text
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${percentage.round()}%',
        style: TextStyle(
          fontSize: radius / 2,
          color: Colors.grey,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final textOffset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    );
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant _BatteryPainter oldDelegate) {
    return percentage != oldDelegate.percentage ||
        strokeWidth != oldDelegate.strokeWidth ||
        backgroundColor != oldDelegate.backgroundColor ||
        foregroundColor != oldDelegate.foregroundColor ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}
