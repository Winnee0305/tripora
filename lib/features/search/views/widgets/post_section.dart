import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/search/viewmodels/post_section_viewmodel.dart';
import 'package:tripora/features/search/views/widgets/travel_post_card.dart';

class PostSection extends StatelessWidget {
  const PostSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PostSectionViewmodel(),
      child: Scaffold(
        body: Consumer<PostSectionViewmodel>(
          builder: (context, vm, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: MasonryGridView.count(
                crossAxisCount: 2, // number of columns
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                itemCount: vm.guides.length,
                itemBuilder: (context, index) {
                  return TravelPostCard(post: vm.guides[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
