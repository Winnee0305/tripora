import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_colors.dart';
import 'package:tripora/core/widgets/pin_icon.dart';

class TimelineIndicator extends StatelessWidget {
  const TimelineIndicator({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.index,
  });

  final bool isFirst;
  final bool isLast;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      child: Column(
        children: [
          // The top line
          if (!isFirst)
            Container(
              width: 1,
              height: 4,
              color: Theme.of(
                context,
              ).colorScheme.secondary.withValues(alpha: 0.6),
            )
          else
            (Container(width: 2, height: 4, color: Colors.transparent)),

          // The pin icon
          PinIcon(number: (index + 1).toString(), color: AppColors.design3),

          // The bottom line
          if (!isLast)
            Expanded(
              child: Container(
                width: 1,
                color: Theme.of(
                  context,
                ).colorScheme.secondary.withValues(alpha: 0.6),
              ),
            ),
        ],
      ),
    );
  }
}
