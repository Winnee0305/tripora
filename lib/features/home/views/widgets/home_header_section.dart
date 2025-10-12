import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/widgets/app_button.dart';
import 'package:flutter/cupertino.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // ----- Profile Picture
          CircleAvatar(
            radius: 32,
            backgroundImage: AssetImage(
              'assets/images/exp_profile_picture.png',
            ),
          ),
          // ----- Greeting Text
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, Winnee!",
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
