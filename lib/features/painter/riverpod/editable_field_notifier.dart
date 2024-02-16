import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditableField {
  const EditableField({
    required this.points,
    required this.tempPoint,
    required this.tempLineLength,
    required this.isPolygonal,
    required this.cancelledPoints,
  });

  final List<Offset> points;
  final Offset tempPoint;
  final double tempLineLength;
  final bool isPolygonal;
  final List<Offset> cancelledPoints;

  EditableField copyWith({
    List<Offset>? points,
    Offset? tempPoint,
    double? tempLineLength,
    bool? isPolygonal,
    List<Offset>? cancelledPoints,
  }) {
    return EditableField(
      points: points ?? this.points,
      tempPoint: tempPoint ?? this.tempPoint,
      tempLineLength: tempLineLength ?? this.tempLineLength,
      isPolygonal: isPolygonal ?? this.isPolygonal,
      cancelledPoints: cancelledPoints ?? this.cancelledPoints,
    );
  }

  @override
  String toString() {
    return 'EditableField(lines: , points: $points, tempPoint: $tempPoint, tempLineLength: $tempLineLength, isPolygonal: $isPolygonal, cancelledPoints: $cancelledPoints)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EditableField &&
        listEquals(other.points, points) &&
        other.tempPoint == tempPoint &&
        other.tempLineLength == tempLineLength &&
        other.isPolygonal == isPolygonal &&
        listEquals(other.cancelledPoints, cancelledPoints);
  }

  @override
  int get hashCode {
    return points.hashCode ^
        tempPoint.hashCode ^
        tempLineLength.hashCode ^
        isPolygonal.hashCode ^
        cancelledPoints.hashCode;
  }
}

class EditableFieldNotifier extends StateNotifier<EditableField> {
  EditableFieldNotifier(super.state);

  void onPanEnd() {
    if (state.isPolygonal != true) {
      List<Offset>? listPoints;
      Offset? tempPoint;
      bool? isPolygonal;

      if (state.points.length > 2 &&
          _arePointsNearby(state.points.first, state.tempPoint, 20)) {
        listPoints = [...state.points, state.points.first];
        tempPoint = state.points.first;
        isPolygonal = true;
      } else {
        listPoints = [...state.points, state.tempPoint];
      }

      state = state.copyWith(
        points: listPoints,
        tempPoint: tempPoint,
        isPolygonal: isPolygonal,
      );
    }
  }

  void onPanDown(Offset tempPoint) {
    if (state.isPolygonal != true) {
      if (state.cancelledPoints.isNotEmpty) {
        state = state.copyWith(cancelledPoints: []);
      }
      state = state.copyWith(
        tempPoint: tempPoint,
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

  void undo() {
    if (state.isPolygonal != true) {
      if (state.points.length > 1) {
        List<Offset>? listPoints = state.points;
        Offset cancelPoint = state.points[listPoints.length - 1];
        listPoints.removeAt(listPoints.length - 1);

        state = state.copyWith(
          cancelledPoints: [...state.cancelledPoints, cancelPoint],
          points: listPoints,
          tempPoint: listPoints.last,
        );
      }
    }
  }

  void redo() {
    if (state.isPolygonal != true) {
      if (state.cancelledPoints.isNotEmpty) {
        List<Offset>? cancelledPoints = state.cancelledPoints;

        state = state.copyWith(
          cancelledPoints: cancelledPoints,
          points: [...state.points, state.cancelledPoints.last],
          tempPoint: state.cancelledPoints.last,
        );
        cancelledPoints.removeAt(state.cancelledPoints.length - 1);
      }
    }
  }

  void clearField() {
    state = state.copyWith(
        points: [],
        tempPoint: const Offset(0, 0),
        tempLineLength: 0.0,
        isPolygonal: false,
        cancelledPoints: []);
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
