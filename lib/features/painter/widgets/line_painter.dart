import 'dart:ui' as ui;

import 'package:drawing_polygons/colors.dart';
import 'package:drawing_polygons/features/painter/riverpod/editable_field_notifier.dart';
import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  final EditableField editableField;
  final ui.Image? image;
  LinePainter(
    this.editableField,
    this.image,
  );

  @override
  void paint(Canvas canvas, Size size) {
    Paint blackPaint = Paint()
      ..color = Palette.blackPaint
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 7.0
      ..style = PaintingStyle.fill;

    Paint bluePaint = Paint()
      ..color = Palette.bluePaint
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    Paint whitePaint = Paint()
      ..color = Palette.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    blackPaint.style = PaintingStyle.fill;
//Use for display text nearby line

    if (editableField.points.isNotEmpty) {
      canvas.drawLine(
          editableField.points.last, editableField.tempPoint, blackPaint);
      _drawPoint(
        canvas: canvas,
        backPaint: bluePaint,
        frontPaint: whitePaint,
      );
      _drawPoint(
          canvas: canvas,
          position: editableField.points.last,
          backPaint: bluePaint,
          frontPaint: whitePaint);
      for (int i = 1; i < editableField.points.length; i++) {
        canvas.drawLine(
            editableField.points[i - 1], editableField.points[i], blackPaint);
        _drawPoint(
            canvas: canvas,
            ind: i,
            backPaint: bluePaint,
            frontPaint: whitePaint);
        _drawPoint(
            canvas: canvas,
            ind: i - 1,
            backPaint: bluePaint,
            frontPaint: whitePaint);
      }
      if (editableField.isPolygonal == false) {
        _displayDistanceBetweenTwoLastPoints(
          canvas: canvas,
          size: size,
        );
      } else {}
    } else {
      _drawPoint(canvas: canvas, backPaint: bluePaint, frontPaint: whitePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void _drawPoint({
    required Canvas canvas,
    int? ind,
    required Paint backPaint,
    required Paint frontPaint,
    Offset? position,
  }) {
    Offset? tempOffset;
    if (position != null) {
      tempOffset = position;
    } else if (ind != null) {
      tempOffset = editableField.points[ind];
    } else {
      tempOffset = editableField.tempPoint;
      if (image != null) {
        final dx = tempOffset.dx - 21.5;
        final dy = tempOffset.dy - 21.5;
        if (editableField.isPolygonal == false) {
          canvas.drawImage(image!, Offset(dx, dy), backPaint);
        }
      }
    }
    canvas.drawCircle(tempOffset, 6.5, backPaint);
    canvas.drawCircle(tempOffset, 5, frontPaint);
  }

  void _displayDistanceBetweenTwoLastPoints(
      {required Canvas canvas, required Size size}) {
    final textStyle = TextStyle(
      color: Palette.bluePaint,
      fontSize: 18,
    );
    final textSpan = TextSpan(
      text: editableField.tempLineLength.toStringAsFixed(2),
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    if (editableField.points.last != editableField.tempPoint) {
      textPainter.paint(
          canvas,
          _calculateAverageOffset(
              editableField.points.last, editableField.tempPoint));
    } else if (editableField.points.length > 1) {
      textPainter.paint(
          canvas,
          _calculateAverageOffset(
              editableField.points[editableField.points.length - 2],
              editableField.points.last));
    }
  }

  Offset _calculateAverageOffset(Offset offset1, Offset offset2) {
    double averageX = (offset1.dx + offset2.dx) / 2;
    double averageY = (offset1.dy + offset2.dy) / 2;

    return Offset(averageX, averageY);
  }
}
