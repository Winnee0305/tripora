// import 'package:flutter/material.dart';
// import 'package:tripora/core/models/note_data.dart';
// import 'package:tripora/core/theme/app_widget_styles.dart';

// class NoteCard extends StatelessWidget {
//   final NoteData note;
//   final VoidCallback? onTap;

//   const NoteCard({super.key, required this.note, this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: AppWidgetStyles.cardDecoration(context).copyWith(
//           border: Border.all(
//             color: theme.colorScheme.outline.withOpacity(0.2),
//             width: 1,
//           ),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Note icon
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     theme.colorScheme.primary.withOpacity(0.1),
//                     theme.colorScheme.primary.withOpacity(0.05),
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(
//                 Icons.sticky_note_2_outlined,
//                 color: theme.colorScheme.primary,
//                 size: 20,
//               ),
//             ),
//             const SizedBox(width: 12),
//             // Note content
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     note.note.isEmpty ? 'Empty note' : note.note,
//                     style: theme.textTheme.bodyMedium?.copyWith(
//                       color: note.note.isEmpty
//                           ? theme.colorScheme.onSurface.withOpacity(0.5)
//                           : theme.colorScheme.onSurface,
//                       fontStyle: note.note.isEmpty
//                           ? FontStyle.italic
//                           : FontStyle.normal,
//                     ),
//                     maxLines: 3,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 8),
//             // Drag handle
//             Icon(
//               Icons.drag_indicator,
//               color: theme.colorScheme.onSurface.withOpacity(0.3),
//               size: 20,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
