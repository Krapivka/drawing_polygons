import 'package:drawing_polygons/colors.dart';
import 'package:drawing_polygons/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class CancelTile extends ConsumerWidget {
  const CancelTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref.read(editableFieldProvider.notifier).clearField();
      },
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: const Color.fromRGBO(253, 253, 253, 1),
          ),
          height: 70,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                color: const Color.fromRGBO(227, 227, 227, 1),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/cancel.svg',
                      height: 13.5,
                      width: 13.5,
                      semanticsLabel: 'Acme Logo',
                    ),
                    Text("Отменить действие",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Palette.darkGrey,
                        )),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
