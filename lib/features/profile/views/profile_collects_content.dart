import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/profile/viewmodels/profile_view_model.dart';
import 'package:tripora/features/exploration/views/widgets/travel_post_card.dart';

class ProfileCollectsContent extends StatelessWidget {
  const ProfileCollectsContent({super.key, required this.vm});

  final ProfileViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // Grid for collects
              Consumer<ProfileViewModel>(
                builder: (context, vm, _) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: MasonryGridView.count(
                      crossAxisCount: 2, // number of columns
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      itemCount: vm.collects.length,
                      shrinkWrap: true, // 👈 important
                      physics: NeverScrollableScrollPhysics(), // 👈 di
                      itemBuilder: (context, index) {
                        return TravelPostCard(post: vm.collects[index]);
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleIconButton(
    BuildContext context,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.maybePop(context),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.orange[50],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: Colors.orange[700]),
      ),
    );
  }
}
