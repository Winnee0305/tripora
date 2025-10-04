import 'package:flutter/material.dart';

class AppExpandableText extends StatefulWidget {
  final String text;
  final int trimLines;
  final TextStyle? style;

  const AppExpandableText(
    this.text, {
    super.key,
    this.trimLines = 4,
    this.style,
  });

  @override
  State<AppExpandableText> createState() => _AppExpandableTextState();
}

class _AppExpandableTextState extends State<AppExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final text = widget.text;
    final textStyle = widget.style ?? Theme.of(context).textTheme.bodyMedium;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Use TextPainter to determine if text exceeds trimLines
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: textStyle),
          maxLines: widget.trimLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflowing = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              textAlign: TextAlign.justify,
              maxLines: isExpanded ? null : widget.trimLines,
              overflow: isExpanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
              style: textStyle,
            ),
            if (isOverflowing)
              GestureDetector(
                onTap: () => setState(() => isExpanded = !isExpanded),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    isExpanded ? "Read less" : "Read more",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
