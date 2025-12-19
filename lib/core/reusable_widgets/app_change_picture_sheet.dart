import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';

/// A reusable Cupertino-style picture picker with confirmation.
/// Returns the confirmed image path, or null if cancelled.
class AppChangePictureSheet {
  /// Shows the full flow (Cupertino Action Sheet + confirmation sheet).
  /// Returns the confirmed image path, or null if cancelled.
  static Future<String?> show(BuildContext context) async {
    final picker = ImagePicker();

    // Step 1: Show Cupertino action sheet for image source selection
    final ImageSource? source = await showCupertinoModalPopup<ImageSource>(
      context: context,
      builder: (_) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(context, ImageSource.camera),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Icon(CupertinoIcons.camera, size: 20),
                    SizedBox(width: 14),
                    Text(
                      'Take Photo',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Icon(CupertinoIcons.photo, size: 20),
                    SizedBox(width: 14),
                    Text(
                      'Choose from Photos',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancel'),
          ),
        );
      },
    );

    if (source == null) return null; // Cancelled

    // Step 2: Pick image
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile == null) return null;

    // Step 3: Confirm before returning
    final String? confirmedImagePath = await _showConfirmPictureSheet(
      context,
      pickedFile.path,
    );

    return confirmedImagePath;
  }

  /// Confirmation sheet (returns confirmed image path or null if cancelled)
  static Future<String?> _showConfirmPictureSheet(
    BuildContext context,
    String imagePath,
  ) async {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Confirm Upload Picture',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.file(
                    File(imagePath),
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppButton.primary(
                      onPressed: () => Navigator.pop(context),
                      icon: CupertinoIcons.xmark,
                      text: 'Cancel',
                      backgroundVariant: BackgroundVariant.secondaryFilled,
                      minWidth: 140,
                      textStyleVariant: TextStyleVariant.medium,
                    ),

                    AppButton.primary(
                      onPressed: () {
                        Navigator.pop(context, imagePath);
                      },
                      icon: CupertinoIcons.check_mark,
                      minWidth: 140,
                      text: 'Comfirm',
                      textStyleVariant: TextStyleVariant.medium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
