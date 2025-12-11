import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/notes/views/widgets/category_button_grid.dart';
import 'package:tripora/features/notes/views/widgets/notes_section.dart';
import '../viewmodels/notes_content_viewmodel.dart';
import '../models/note_base.dart';

class NotesContent extends StatefulWidget {
  const NotesContent({super.key});

  @override
  State<NotesContent> createState() => _NotesContentState();
}

class _NotesContentState extends State<NotesContent> {
  final scrollController = ScrollController();

  // Map each section type to its GlobalKey for scroll positioning
  final sectionKeys = {
    NoteType.attraction: GlobalKey(),
    NoteType.lodging: GlobalKey(),
    NoteType.restaurant: GlobalKey(),
    NoteType.transportation: GlobalKey(),
    NoteType.note: GlobalKey(),
    NoteType.attachment: GlobalKey(),
  };

  void scrollToSection(NoteType type) {
    final key = sectionKeys[type];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (_) => NotesContentViewModel(),
      child: Consumer<NotesContentViewModel>(
        builder: (context, vm, _) {
          final typeCounts = {
            NoteType.attraction: vm.attractions.length,
            NoteType.restaurant: vm.restaurants.length,
            NoteType.transportation: vm.transportations.length,
            NoteType.note: vm.tickets.length,
            NoteType.lodging: vm.lodgings.length,
            NoteType.attachment: vm.attachments.length,
          };

          return Column(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text('Your notes', style: theme.textTheme.headlineSmall),
                    // Top Category Buttons
                    CategoryButtonGrid(
                      counts: typeCounts,
                      onPressed: scrollToSection,
                    ),
                    const SizedBox(height: 12),

                    // Sections
                    NotesSection(
                      key: sectionKeys[NoteType.attraction],
                      title: 'Attractions',
                      icon: Icons.place,
                      children: vm.attractions,
                    ),
                    NotesSection(
                      key: sectionKeys[NoteType.lodging],
                      title: 'Lodging',
                      icon: Icons.hotel,
                      children: vm.lodgings,
                    ),
                    NotesSection(
                      key: sectionKeys[NoteType.restaurant],
                      title: 'Restaurants',
                      icon: Icons.restaurant,
                      children: vm.restaurants,
                    ),
                    NotesSection(
                      key: sectionKeys[NoteType.transportation],
                      title: 'Transportations',
                      icon: Icons.directions_bus,
                      children: vm.transportations,
                    ),
                    NotesSection(
                      key: sectionKeys[NoteType.note],
                      title: 'Tickets',
                      icon: Icons.confirmation_number,
                      children: vm.tickets,
                    ),
                    NotesSection(
                      key: sectionKeys[NoteType.attachment],
                      title: 'Attachments',
                      icon: Icons.attachment,
                      children: vm.attachments,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
