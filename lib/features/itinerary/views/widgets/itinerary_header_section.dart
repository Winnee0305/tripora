import 'package:flutter/cupertino.dart';
import 'package:tripora/core/widgets/app_button.dart';

class ItineraryHeaderSection extends StatelessWidget {
  const ItineraryHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppButton.iconOnly(
              icon: CupertinoIcons.back,
              onPressed: () => Navigator.pop(context),
              backgroundVariant: BackgroundVariant.secondaryFilled,
            ),

            AppButton.iconOnly(
              icon: CupertinoIcons.home,
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              backgroundVariant: BackgroundVariant.secondaryFilled,
            ),
          ],
        ),
      ),
    );
  }
}
