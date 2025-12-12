import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/exploration/viewmodels/search_suggestion_viewmodel.dart';
import 'package:tripora/features/exploration/views/widgets/post_section.dart';
import 'package:tripora/features/exploration/views/widgets/location_search_bar.dart';
import 'package:tripora/features/exploration/views/widgets/search_suggestion_section.dart';
import 'package:tripora/features/poi/views/poi_page.dart';

class ExplorationPage extends StatefulWidget {
  const ExplorationPage({super.key});

  @override
  State<ExplorationPage> createState() => _ExplorationPageState();
}

class _ExplorationPageState extends State<ExplorationPage>
    with SingleTickerProviderStateMixin {
  bool _isSearching = false;
  final FocusNode _searchFocusNode = FocusNode();

  void _activateSearch() {
    setState(() => _isSearching = true);
    _searchFocusNode.requestFocus();
  }

  void _deactivateSearch() {
    setState(() => _isSearching = false);
    _searchFocusNode.unfocus();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchSuggestionViewModel(),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                top: 80,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: _isSearching
                      // ? const SearchSuggestionSection(key: ValueKey('search'))
                      ? SearchSuggestionSection(
                          key: ValueKey('search'),
                          onItemSelected: (description, suggestion) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PoiPage(placeId: suggestion['place_id']),
                              ),
                            );
                          },
                        )
                      : const PostSection(key: ValueKey('posts')),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _activateSearch,
                        child: AbsorbPointer(
                          absorbing: !_isSearching,
                          child: LocationSearchBar(focusNode: _searchFocusNode),
                        ),
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _isSearching
                          ? SizedBox(
                              key: const ValueKey('cancel'),
                              width: 80,
                              child: TextButton(
                                onPressed: _deactivateSearch,
                                child: Text(
                                  "Cancel",
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                ),
                              ),
                            )
                          : const SizedBox(key: ValueKey('empty'), width: 0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
