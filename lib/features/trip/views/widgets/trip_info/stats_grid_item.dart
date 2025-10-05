// import 'package:flutter/material.dart';

// class StatsGridItem extends StatelessWidget {
//   final Color color;
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final double? iconSize;

//   const StatsGridItem({
//     super.key,
//     required this.color,
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     this.iconSize,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: Colors.white, size: iconSize ?? 32),
//           const Spacer(),
//           Text(
//             title,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 13,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//           Text(
//             subtitle,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
