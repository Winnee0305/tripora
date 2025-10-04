// import 'package:flutter/material.dart';

// class AppTransButton extends StatelessWidget {
//   final VoidCallback? onPressed;
//   final IconData icon;
//   final double size; // diameter of the circle
//   final Color? backgroundColor;
//   final Color? iconColor;
//   final List<BoxShadow>? boxShadow;

//   const AppTransButton({
//     super.key,
//     required this.onPressed,
//     required this.icon,
//     this.size = 40,
//     this.backgroundColor,
//     this.iconColor,
//     this.boxShadow,
//     this.text,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: size,
//       height: size,
//       child: DecoratedBox(
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color:
//               backgroundColor ??
//               Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
//           boxShadow: boxShadow,
//         ),
//         child: IconButton(
//           onPressed: onPressed,
//           icon: Icon(
//             icon,
//             color: iconColor ?? Theme.of(context).colorScheme.primary,
//           ),
//           iconSize: size * 0.6, // keeps padding balanced inside circle
//           splashRadius: size * 0.6,
//           padding: EdgeInsets.zero, // avoid extra padding
//         ),
//       ),
//     );
//   }
// }
