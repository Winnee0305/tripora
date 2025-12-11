import 'package:flutter/material.dart';
import 'package:tripora/core/models/note_data.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/core/reusable_widgets/app_text_field.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';

class AddEditNoteBottomSheet extends StatefulWidget {
  final NoteData? note;
  const AddEditNoteBottomSheet({super.key, this.note});

  @override
  State<AddEditNoteBottomSheet> createState() => _AddEditNoteBottomSheetState();
}

class _AddEditNoteBottomSheetState extends State<AddEditNoteBottomSheet> {
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _noteController.text = widget.note!.note;
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = MediaQuery.of(context).viewInsets;

    final isEditing = widget.note?.id.isNotEmpty ?? false;

    return Padding(
      padding: EdgeInsets.only(bottom: padding.bottom),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: AppWidgetStyles.cardDecoration(context).copyWith(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.2),
                          theme.colorScheme.primary.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.sticky_note_2_outlined,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isEditing ? "Edit Note" : "Add Note",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Note field
              AppTextField(
                label: "Note",
                controller: _noteController,
                maxLines: 5,
                minLines: 3,
              ),
              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  if (isEditing) ...[
                    Expanded(
                      child: AppButton.textOnly(
                        text: 'Delete',
                        radius: 12,
                        minHeight: 48,
                        backgroundVariant: BackgroundVariant.danger,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: const Text('Delete Note'),
                              content: const Text(
                                'Are you sure you want to delete this note?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                    Navigator.pop(context, 'delete');
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: 2,
                    child: AppButton.textOnly(
                      text: isEditing ? 'Update' : 'Add Note',
                      radius: 12,
                      minHeight: 48,
                      onPressed: () {
                        if (_noteController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a note'),
                            ),
                          );
                          return;
                        }

                        final note = NoteData(
                          id: widget.note?.id ?? '',
                          note: _noteController.text.trim(),
                          date: widget.note?.date ?? DateTime.now(),
                          sequence: widget.note?.sequence ?? 0,
                          lastUpdated: DateTime.now(),
                        );

                        Navigator.pop(context, note);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
