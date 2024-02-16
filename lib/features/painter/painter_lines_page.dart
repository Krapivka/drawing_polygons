import 'dart:ui' as ui;
import 'package:drawing_polygons/features/painter/widgets/backgroud_with_dots.dart';
import 'package:drawing_polygons/features/painter/widgets/cancel_tile.dart';
import 'package:drawing_polygons/features/painter/widgets/info_tile.dart';
import 'package:drawing_polygons/features/painter/widgets/line_painter.dart';
import 'package:drawing_polygons/features/painter/widgets/polygon_painter.dart';
import 'package:drawing_polygons/features/painter/widgets/undo_redo_button.dart';
import 'package:drawing_polygons/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PainterLinesPage extends StatelessWidget {
  const PainterLinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Stack(children: [
          BackgroundWithDots(),
          PainterLinesView(),
        ])));
  }
}

class PainterLinesView extends ConsumerWidget {
  const PainterLinesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editableField = ref.watch(editableFieldProvider);
    AsyncValue<ui.Image> image = ref.watch(imageProvider);
    return Stack(
      children: [
        GestureDetector(
            onPanEnd: (DragEndDetails details) {
              ref.read(editableFieldProvider.notifier).onPanEnd();
            },
            onPanDown: (details) {
              ref
                  .read(editableFieldProvider.notifier)
                  .onPanDown(details.globalPosition);
            },
            onPanUpdate: (details) {
              ref
                  .read(editableFieldProvider.notifier)
                  .onPanUpdate(details.globalPosition);
            },
            child: image.when(
                data: (image) {
                  return Stack(
                    children: [
                      editableField.isPolygonal == true
                          ? CustomPaint(
                              painter:
                                  PolygonPainter(points: editableField.points),
                            )
                          : const SizedBox(),
                      CustomPaint(
                          painter: LinePainter(editableField, image),
                          child: const SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                          )),
                    ],
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (err, stack) => Text('Error: $err'))),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UndoRedoButton(),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InfoTile(),
                  SizedBox(
                    height: 10,
                  ),
                  CancelTile()
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
