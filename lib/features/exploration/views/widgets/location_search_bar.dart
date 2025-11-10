import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/reusable_widgets/app_text_field2.dart';
import 'package:tripora/features/exploration/viewmodels/search_suggestion_viewmodel.dart';

class LocationSearchBar extends StatelessWidget {
  final FocusNode? focusNode;

  const LocationSearchBar({super.key, this.focusNode});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SearchSuggestionViewModel>(context);

    return Column(
      children: [
        AppTextField2(
          focusNode: focusNode,
          hintText: "Search destinations...",
          icon: CupertinoIcons.search,
          onChanged: viewModel.onSearchChanged,
        ),

        if (viewModel.suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
          ),
      ],
    );
  }
}
