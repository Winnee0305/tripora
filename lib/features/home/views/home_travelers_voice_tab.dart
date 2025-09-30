import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/home/viewmodels/travelers_voice_viewmodel.dart';
import 'package:tripora/features/home/views/widgets/travel_post_card.dart';

class HomeTravelersVoiceTab extends StatelessWidget {
  const HomeTravelersVoiceTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TravelersVoiceViewmodel(),
      child: Scaffold(
        body: Consumer<TravelersVoiceViewmodel>(
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
