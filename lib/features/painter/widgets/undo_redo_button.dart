import 'package:drawing_polygons/colors.dart';
import 'package:drawing_polygons/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class UndoRedoButton extends ConsumerWidget {
  const UndoRedoButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fieldProvider = ref.watch(editableFieldProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            height: 31,
            decoration: BoxDecoration(
                color: Palette.white, borderRadius: BorderRadius.circular(5.3)),
            child: Row(
              children: [
                InkWell(
                  onTap: () => ref.read(editableFieldProvider.notifier).undo(),
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: SvgPicture.asset('assets/undo.svg',
                        height: 16,
                        width: 19,
                        semanticsLabel: 'Acme Logo',
                        color: fieldProvider.isPolygonal ||
                                fieldProvider.points.length <= 1
                            ? Palette.lightGrey
                            : Palette.darkGrey),
                  ),
                ),
                VerticalDivider(
                  color: Palette.lightGrey,
                  thickness: 1,
                ),
                InkWell(
                  onTap: () => ref.read(editableFieldProvider.notifier).redo(),
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: SvgPicture.asset('assets/redo.svg',
                        height: 16,
                        width: 19,
                        semanticsLabel: 'Acme Logo',
                        color: fieldProvider.isPolygonal ||
                                fieldProvider.cancelledPoints.isEmpty
                            ? Palette.lightGrey
                            : Palette.darkGrey),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
