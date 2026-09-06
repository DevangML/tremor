import 'package:flutter/material.dart';

final class MagnitudeBadgeWidget extends StatelessWidget {
  const new({required this.mag, required this.color, super.key});

  final double mag;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 54,
      height: 54,
      child: CustomPaint(
        painter: MagnitudeRingPainter(mag: mag, color: color),
        child: Center(
          child: Text(
            mag.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

final class MagnitudeRingPainter extends CustomPainter {
  const new({required this.mag, required this.color});

  final double mag;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.width / 2) - 4;

    final trackPaint = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;
    canvas.drawCircle(center, radius, trackPaint);

    final sweepAngle = (mag / 10.0) * 2 * 3.141592653589793;
    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592653589793 / 2,
      sweepAngle,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant MagnitudeRingPainter oldDelegate) {
    return oldDelegate.mag != mag || oldDelegate.color != color;
  }
}
