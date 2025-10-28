import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripora/features/profile/viewmodels/profile_view_model.dart';
import 'package:tripora/features/profile/views/profile_page.dart';
import 'package:tripora/features/user/viewmodels/user_viewmodel.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final userVm = context.watch<UserViewModel>();
    debugPrint("current user id: ${userVm.user?.uid}");
    debugPrint("username: ${userVm.user?.lastname}");
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // ----- Profile Picture
          GestureDetector(
            child: CircleAvatar(
              radius: 32,
              backgroundImage: AssetImage(
                'assets/images/exp_profile_picture.png',
              ),
            ),
            onTap: () {
              final vm = context.read<UserViewModel>();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider<UserViewModel>.value(
                    value: vm,
                    child: const ProfilePage(),
                  ),
                ),
              );
            },
          ),
          // ----- Greeting Text
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, ${userVm.user?.lastname ?? 'Guest'}",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 4),
              Text(
                "Explore the best journey with us",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: ManropeFontWeight.light,
                ),
              ),
            ],
          ),
          const Spacer(),
          Stack(
            children: [
              AppButton.iconOnly(
                icon: CupertinoIcons.bell,
                onPressed: () {},
                backgroundVariant: BackgroundVariant.primaryTrans,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: AppButton.textOnly(
                  minWidth: 16,
                  minHeight: 16,
                  text: "3",
                  textStyleOverride: Theme.of(
                    context,
                  ).textTheme.labelMedium?.copyWith(color: Colors.white),
                  backgroundColorOverride: Colors.red,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
