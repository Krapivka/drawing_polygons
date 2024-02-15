import 'package:drawing_polygons/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BackForwardButton extends StatelessWidget {
  const BackForwardButton({super.key});

  @override
  Widget build(BuildContext context) {
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
                SvgPicture.asset(
                  'assets/back.svg',
                  height: 16,
                  width: 19,
                  semanticsLabel: 'Acme Logo',
                ),
                const VerticalDivider(
                  color: Colors.black,
                  thickness: 1,
                ),
                SvgPicture.asset(
                  'assets/forward.svg',
                  height: 16,
                  width: 19,
                  semanticsLabel: 'Acme Logo',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
