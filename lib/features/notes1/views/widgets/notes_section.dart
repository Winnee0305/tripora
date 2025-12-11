import 'package:flutter/material.dart';
import 'package:tripora/features/notes/views/widgets/note_card_factory.dart';

class NotesSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<dynamic> children;

  const NotesSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 18),
        Row(
          children: [
            Icon(icon, color: Colors.orange),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (children.isEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('No notes added yet.'),
          )
        else
          ...children.map((note) => NoteCardFactory(note: note)).toList(),
      ],
    );
  }
}
