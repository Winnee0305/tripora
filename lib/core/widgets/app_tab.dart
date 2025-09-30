import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_shadow_theme.dart';

class AppTab extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final double spacing;
  final double underlineHeight;
  final double underlineSpacing;
  final TextStyle? textStyle;
  final Color activeColor;
  final Color inactiveColor;

  const AppTab({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.spacing = 2,
    this.underlineHeight = 2,
    this.underlineSpacing = 28,
    this.textStyle,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tabWidths = <double>[];
        for (var label in tabs) {
          final painter = TextPainter(
            text: TextSpan(
              text: label,
              style:
                  textStyle ??
                  const TextStyle(
                    fontSize: 16,
                    fontWeight: ManropeFontWeight.regular,
                  ),
            ),
            maxLines: 1,
            textDirection: TextDirection.ltr,
          )..layout();
          tabWidths.add(painter.width);
        }

        final totalTextWidth = tabWidths.reduce((a, b) => a + b);
        final double spacingValue = tabs.length > 1
            ? (constraints.maxWidth - totalTextWidth) / (tabs.length - 1)
            : 0;

        // Compute underline left offset
        double leftOffset = 0;
        for (int i = 0; i < selectedIndex; i++) {
          leftOffset += tabWidths[i] + spacingValue;
        }

        return SizedBox(
          height: 60,
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              // Tabs row
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    tabs.length,
                    (index) => GestureDetector(
                      onTap: () => onTabSelected(index),
                      child: Text(
                        tabs[index],
                        style:
                            (textStyle ??
                                    const TextStyle(
                                      fontSize: 16,
                                      fontWeight: ManropeFontWeight.regular,
                                    ))
                                .copyWith(
                                  color: selectedIndex == index
                                      ? activeColor
                                      : inactiveColor,
                                ),
                      ),
                    ),
                  ),
                ),
              ),

              // Sliding underline
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                left: leftOffset,
                bottom: underlineSpacing,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: underlineHeight,
                  width: tabWidths[selectedIndex],
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        activeColor.withOpacity(0.0),
                        activeColor,
                        activeColor.withOpacity(0.0),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
