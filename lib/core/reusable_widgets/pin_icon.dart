import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripora/core/theme/app_text_style.dart';

class PinIcon extends StatelessWidget {
  const PinIcon({super.key, required this.number, required this.color});

  final String number;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(CupertinoIcons.location_solid, color: color, size: 30),
        Positioned(
          top: 6,
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
        Positioned(
          top: 7,
          child: Text(
            number,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: ManropeFontWeight.extraBold,
            ),
          ), // color: Colors.white,
          // fontWeight: FontWeight.bold,
          // // fontSize: 12,
        ),

        // style: const TextStyle(
        //   fontSize: 12,
        //   fontWeight: FontWeight.bold,
        //   color: Colors.white,
        // ),
      ],
    );
  }
}
