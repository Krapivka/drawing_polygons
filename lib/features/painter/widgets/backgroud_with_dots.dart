import 'package:drawing_polygons/colors.dart';
import 'package:flutter/material.dart';

class BackgroundWithDots extends StatelessWidget {
  const BackgroundWithDots({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.lightGrey,
      child: const Stack(
        children: [
          Positioned.fill(child: DottedBackground()),
        ],
      ),
    );
  }
}

class DottedBackground extends StatelessWidget {
  const DottedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DottedPainter(),
    );
  }
}

class DottedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Palette.bluePaint
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.5;

    const spacing = 30.0;

    for (double i = 0; i < size.width; i += spacing) {
      for (double j = 0; j < size.height; j += spacing) {
        canvas.drawCircle(Offset(i, j), 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
