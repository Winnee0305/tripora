import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';

/// A reusable animated bubble background with a soft blur layer.
/// The blur applies only to the background, not the foreground child.
///
/// Example:
/// ```dart
/// BubbleAnimatedBackground(
///   baseColor: Colors.blueAccent,
///   child: YourPageContent(),
/// )
/// ```
class BubbleAnimatedBackground extends StatefulWidget {
  final Widget child;
  final Color baseColor;

  const BubbleAnimatedBackground({
    super.key,
    required this.child,
    required this.baseColor,
  });

  @override
  State<BubbleAnimatedBackground> createState() =>
      _BubbleAnimatedBackgroundState();
}

class _BubbleAnimatedBackgroundState extends State<BubbleAnimatedBackground>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // --- Layer 1: Animated bubbles ---
        Positioned.fill(
          child: RepaintBoundary(
            child: ExcludeSemantics(
              child: AnimatedBackground(
                vsync: this,
                behaviour: RandomParticleBehaviour(
                  options: ParticleOptions(
                    baseColor: widget.baseColor.withOpacity(0.4),
                    spawnMinRadius: 40.0,
                    spawnMaxRadius: 100.0,
                    spawnMaxSpeed: 90.0,
                    spawnMinSpeed: 30.0,
                    particleCount: 12,
                    minOpacity: 0.1,
                    maxOpacity: 0.3,
                  ),
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),

        // --- Layer 2: Subtle blur overlay (only background) ---
        Positioned.fill(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),

        // --- Layer 3: Foreground content (clear and sharp) ---
        Positioned.fill(child: widget.child),
      ],
    );
  }
}
