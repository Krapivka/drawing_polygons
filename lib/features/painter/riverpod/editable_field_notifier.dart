import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Line {
  final Offset start;
  final Offset end;

  Line(this.start, this.end);
}

class EditableField {
  const EditableField({
    required this.lines,
    required this.points,
    required this.tempPoint,
    required this.tempLineLength,
    required this.isPolygonal,
  });

  final List<Line> lines;
  final List<Offset> points;
  final Offset tempPoint;
  final double tempLineLength;
  final bool isPolygonal;

  EditableField copyWith({
    List<Line>? lines,
    List<Offset>? points,
    Offset? tempPoint,
    double? tempLineLength,
    bool? isPolygonal,
  }) {
    return EditableField(
      lines: lines ?? this.lines,
      points: points ?? this.points,
      tempPoint: tempPoint ?? this.tempPoint,
      tempLineLength: tempLineLength ?? this.tempLineLength,
      isPolygonal: isPolygonal ?? this.isPolygonal,
    );
  }

  @override
  String toString() {
    return 'EditableField(lines: $lines, points: $points, tempPoint: $tempPoint, tempLineLength: $tempLineLength, isPolygonal: $isPolygonal)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EditableField &&
        listEquals(other.lines, lines) &&
        listEquals(other.points, points) &&
        other.tempPoint == tempPoint &&
        other.tempLineLength == tempLineLength &&
        other.isPolygonal == isPolygonal;
  }

  @override
  int get hashCode {
    return lines.hashCode ^
        points.hashCode ^
        tempPoint.hashCode ^
        tempLineLength.hashCode ^
        isPolygonal.hashCode;
  }
}

class EditableFieldNotifier extends StateNotifier<EditableField> {
  EditableFieldNotifier(super.state);

  void onPanEnd() {
    if (state.isPolygonal != true) {
      List<Offset>? listDot;
      Offset? tempPoint;
      bool? isPolygonal;

      if (state.points.length > 2 &&
          _arePointsNearby(state.points.first, state.tempPoint, 20)) {
        listDot = [...state.points, state.points.first];
        tempPoint = state.points.first;
        isPolygonal = true;
      } else {
        listDot = [...state.points, state.tempPoint];
      }

      state = state.copyWith(
        points: listDot,
        tempPoint: tempPoint,
        isPolygonal: isPolygonal,
      );
    }
  }

  void onPanUpdate(Offset tempPoint) {
    if (state.isPolygonal != true) {
      double? tempLineLength;
      if (state.points.isNotEmpty) {
        tempLineLength = _calculateDistance(state.points.last, tempPoint);
      }
      state =
          state.copyWith(tempPoint: tempPoint, tempLineLength: tempLineLength);
    }
  }

  void clearField() {
    state = state.copyWith(
        lines: [],
        points: [],
        tempPoint: const Offset(0, 0),
        tempLineLength: 0.0,
        isPolygonal: false);
  }

  bool _arePointsNearby(Offset point1, Offset point2, double factor) {
    if ((point2.dx - point1.dx).abs() < factor &&
        (point2.dy - point1.dy).abs() < factor) {
      return true;
    }
    return false;
  }

  double _calculateDistance(Offset point1, Offset point2) {
    double deltaX = point1.dx - point2.dx;
    double deltaY = point1.dy - point2.dy;
    double k = 25;
    double distance = sqrt(deltaX * deltaX + deltaY * deltaY) / k;

    return distance;
  }
}
