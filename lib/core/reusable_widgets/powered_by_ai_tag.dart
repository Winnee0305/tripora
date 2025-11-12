import 'package:flutter/material.dart';

class PoweredByAiTag extends StatelessWidget {
  const PoweredByAiTag({super.key});

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: [
        Color(0xFF8A2BE2), // violet
        Color(0xFF00BFFF), // blue
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => gradient.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_awesome,
                  size: 14,
                  color: Colors.white, // overridden by shader
                ),
                const SizedBox(width: 4),
                Text(
                  "Powered by Gemini",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // overridden by shader
                  ),
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
