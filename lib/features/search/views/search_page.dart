import 'package:flutter/material.dart';
import 'package:tripora/features/search/views/widgets/search_bar.dart';
import 'package:tripora/features/search/views/widgets/post_section.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: AppSearchBar(),
            ),
            SizedBox(height: 24),
            Expanded(child: PostSection()),
          ],
        ),
      ),
    );
  }
}
