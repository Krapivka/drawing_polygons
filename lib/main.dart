import 'dart:ui' as ui;

import 'package:drawing_polygons/features/painter/riverpod/editable_field_notifier.dart';
import 'package:drawing_polygons/features/painter/painter_lines_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final editableFieldProvider =
    StateNotifierProvider<EditableFieldNotifier, EditableField>(
        (ref) => EditableFieldNotifier(
              const EditableField(
                points: [],
                tempPoint: Offset(0, 0),
                tempLineLength: 0,
                isPolygonal: false,
                cancelledPoints: [],
              ),
            ));

final imageProvider = FutureProvider<ui.Image>((ref) async {
  final ByteData data = await rootBundle.load('assets/arrows.png');
  final Uint8List bytes = data.buffer.asUint8List();
  final ui.Codec codec = await ui.instantiateImageCodec(bytes);
  final ui.FrameInfo frameInfo = await codec.getNextFrame();
  return frameInfo.image;
});

void main() {
  runApp(const ProviderScope(
    child: PainterLinesPage(),
  ));
}
