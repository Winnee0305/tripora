import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/reusable_widgets/app_ink_well.dart';
import 'package:tripora/core/services/place_details_service.dart';
import 'package:tripora/features/exploration/viewmodels/search_suggestion_viewmodel.dart';
import 'package:tripora/features/poi/views/poi_page.dart';

class SearchSuggestionSection extends StatelessWidget {
  final void Function(String description, Map<String, dynamic> suggestion)?
  onItemSelected;

  const SearchSuggestionSection({super.key, this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SearchSuggestionViewModel>();

    if (viewModel.suggestions.isEmpty) {
      return const SizedBox.shrink(); // nothing to show
    }

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: viewModel.suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = viewModel.suggestions[index];
          final description = suggestion['description'] ?? "Unknown";
          return AppInkWell(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => PoiPage(placeId: suggestion['place_id']),
              //   ),
              // );
              if (onItemSelected != null) {
                onItemSelected!(description, suggestion);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.location_solid,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      suggestion['description'] ?? "Unknown",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
