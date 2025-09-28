import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_text_style.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final int notificationCount;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // allows badge to overflow
      children: [
        ElevatedButton(
          onPressed: onPressed ?? () {},
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.2),
            shadowColor: Colors.transparent,
            padding: EdgeInsets.zero,
            minimumSize: const Size(40, 40),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 28,
          ),
        ),
        if (notificationCount > 0)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Center(
                child: Text(
                  '$notificationCount',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: ManropeFontWeight
                        .bold, // or ManropeFontWeight.bold if custom/ replace 14 with your size
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
