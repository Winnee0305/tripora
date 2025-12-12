import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/reusable_widgets/app_change_picture_sheet.dart';
import 'package:tripora/core/reusable_widgets/app_loading_network_image.dart';
import 'package:tripora/core/reusable_widgets/app_toast.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/features/user/viewmodels/user_viewmodel.dart';
import 'package:tripora/features/profile/viewmodels/profile_view_model.dart';
import 'package:tripora/features/profile/views/widgets/stat_card.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key, required this.vm});

  final ProfileViewModel vm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userVm = context.watch<UserViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userVm.toastMessage != null) {
        AppToast(context, userVm.toastMessage!);
        userVm.toastMessage = null; // reset after showing
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ----- Profile Picture with Edit Action -----
        GestureDetector(
          onTap: () async {
            final imagePath = await AppChangePictureSheet.show(context);
            if (imagePath != null) {
              userVm.updateProfilePicture(imagePath, context);
            }
          },

          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipOval(
                    child: SizedBox(
                      width: 108,
                      height: 108,
                      child: AppLoadingNetworkImage(
                        imageUrl: userVm.user!.profileImageUrl ?? "",
                        radius: 14,
                      ),
                    ),
                  ),

                  if (userVm.isImageLoading)
                    const CircleAvatar(
                      radius: 54,
                      backgroundColor: Colors.white70,
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: CupertinoActivityIndicator(radius: 14),
                      ),
                    ),
                ],
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
        ),
        const SizedBox(height: 12),

        // ----- Username -----
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

        // ----- Stats -----
        SizedBox(
          height: 84,
          child: vm.isLoadingCounts
              ? const Center(child: CupertinoActivityIndicator())
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: [
                    StatCard(
                      label: 'Trips\nCreated',
                      value: '${vm.tripsCreatedCount}',
                    ),
                    StatCard(
                      label: 'Shared\nTrips',
                      value: '${vm.sharedTripsCount}',
                    ),
                    StatCard(
                      label: 'Collection',
                      value: '${vm.collectionsCount}',
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 22),
      ],
    );
  }
}
