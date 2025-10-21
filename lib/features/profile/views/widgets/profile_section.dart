import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/features/profile/viewmodels/profile_view_model.dart';
import 'package:tripora/features/profile/views/widgets/stat_card.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key, required this.vm});

  final ProfileViewModel vm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ----- Profile Picture with edit icon
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 54,
              backgroundImage: AssetImage(
                "assets/images/exp_profile_picture.png",
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.surface,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: const Icon(CupertinoIcons.pencil, size: 18),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ----- Username
        Text(
          "${vm.user.firstname}, ${vm.user.lastname}",
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          "@${vm.user.username}",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
            fontWeight: ManropeFontWeight.semiBold,
          ),
        ),
        const SizedBox(height: 18),

        // ----- Stats
        SizedBox(
          height: 84,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              // StatCard(label: 'Following', value: '${vm.user.following}'),
              // StatCard(label: 'Followers', value: '${vm.user.followers}'),
              StatCard(label: 'Following', value: '4'),
              StatCard(label: 'Followers', value: '1'),

              StatCard(
                label: 'Likes &\nComments',
                // value: '${vm.user.likesComments}',
                value: '12',
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
      ],
    );
  }
}
