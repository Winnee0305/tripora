import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/features/itinerary/viewmodels/itinerary_view_model.dart';

class NotesItineraryPageHeaderSection extends StatelessWidget {
  const NotesItineraryPageHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final itineraryVm = context.watch<ItineraryViewModel>();
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
            Row(
              children: [
                // Cloud sync button
                if (itineraryVm.isSync)
                  AppButton.iconOnly(
                    minWidth: 80,
                    minHeight: 40,
                    iconWidget: Image.asset(
                      'assets/icons/cloud_check.png',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {},
                    backgroundVariant: BackgroundVariant.secondaryFilled,
                  )
                else if (itineraryVm.isUploading)
                  AppButton.iconOnly(
                    minWidth: 80,
                    minHeight: 40,
                    iconWidget: Image.asset(
                      'assets/icons/cloud_sync.gif',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {},
                    backgroundVariant: BackgroundVariant.secondaryFilled,
                  )
                else
                  AppButton.iconOnly(
                    minWidth: 80,
                    minHeight: 40,
                    iconWidget: Image.asset(
                      'assets/icons/cloud_upload.png',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {
                      itineraryVm.syncItineraries();
                    },
                    backgroundVariant: BackgroundVariant.secondaryFilled,
                  ),
                const SizedBox(width: 10),

                // Share button
                AppButton.iconOnly(
                  icon: CupertinoIcons.share,
                  minWidth: 80,
                  minHeight: 40,
                  onPressed: () {}, // TODO
                  backgroundVariant: BackgroundVariant.secondaryFilled,
                ),
              ],
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
