import 'package:flutter/material.dart';

class PolygonPainter extends CustomPainter {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  PolygonPainter(
      {required this.points,
      this.color = Colors.white,
      this.strokeWidth = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(PolygonPainter oldDelegate) {
    return true;
  }
}
