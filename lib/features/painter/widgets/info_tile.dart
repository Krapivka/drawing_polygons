import 'package:drawing_polygons/colors.dart';
import 'package:drawing_polygons/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InfoTile extends ConsumerWidget {
  const InfoTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool visible = !ref.watch(editableFieldProvider).isPolygonal;
    return Visibility(
      visible: visible,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: Palette.white,
        ),
        height: 52,
        width: MediaQuery.of(context).size.width,
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Нажмите на любую точку экрана, чтобы построить угол",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
