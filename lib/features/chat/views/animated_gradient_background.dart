import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class BubbleGradientBackground extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  const BubbleGradientBackground({
    super.key,
    required this.child,
    required this.baseColor,
  });

  @override
  State<BubbleGradientBackground> createState() =>
      _BubbleGradientBackgroundState();
}

class _BubbleGradientBackgroundState extends State<BubbleGradientBackground>
    with TickerProviderStateMixin {
  // ✅ Safer initialization (no late)
  List<_Bubble> bubbles = [];
  List<_Bubble> shimmerBubbles = [];

  @override
  void initState() {
    super.initState();
    final random = Random();
    final colors = SoftColorPalette.generateSoftPalette(widget.baseColor);

    // 🌤 Main soft bubbles
    bubbles = List.generate(5, (i) {
      final controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: 14 + random.nextInt(10)),
      )..repeat(reverse: true);

      return _Bubble(
        controller: controller,
        startOffset: Offset(random.nextDouble(), random.nextDouble()),
        color: [colors[1], colors[2], colors[3], colors[4], colors[5]][i % 5],
        sizeFactor: 0.7 + random.nextDouble() * 0.7,
        opacity: 0.35,
        speed: 0.1,
        blurSigma: 0,
      );
    });

    // ✨ Shimmer bubbles (smaller + faster)
    shimmerBubbles = List.generate(3, (i) {
      final controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: 6 + random.nextInt(6)),
      )..repeat(reverse: true);

      return _Bubble(
        controller: controller,
        startOffset: Offset(random.nextDouble(), random.nextDouble()),
        color: Colors.white,
        sizeFactor: 0.25 + random.nextDouble() * 0.15,
        opacity: 0.12,
        speed: 0.25,
        blurSigma: 20,
      );
    });
  }

  @override
  void dispose() {
    for (final b in bubbles) {
      b.controller.dispose();
    }
    for (final b in shimmerBubbles) {
      b.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: Listenable.merge([
            ...bubbles.map((b) => b.controller),
            ...shimmerBubbles.map((b) => b.controller),
          ]),
          builder: (context, child) {
            return Stack(
              children: [
                // 🌤 Soft bubbles
                ...bubbles.map((b) {
                  final p = b.controller.value;
                  final dx = b.startOffset.dx + b.speed * sin(p * 2 * pi);
                  final dy = b.startOffset.dy + b.speed * cos(p * 2 * pi);

                  final size = constraints.maxWidth * b.sizeFactor;
                  return Positioned(
                    top: dy * constraints.maxHeight,
                    left: dx * constraints.maxWidth,
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            b.color.withOpacity(b.opacity),
                            b.color.withOpacity(0.6),
                          ],
                          radius: 0.8,
                        ),
                      ),
                    ),
                  );
                }),

                // ✨ Shimmer bubbles
                ...shimmerBubbles.map((b) {
                  final p = b.controller.value;
                  final dx = b.startOffset.dx + b.speed * sin(p * 2 * pi);
                  final dy = b.startOffset.dy + b.speed * cos(p * 2 * pi);

                  final size = constraints.maxWidth * b.sizeFactor;
                  return Positioned(
                    top: dy * constraints.maxHeight,
                    left: dx * constraints.maxWidth,
                    child: ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: b.blurSigma,
                          sigmaY: b.blurSigma,
                        ),
                        child: Container(
                          width: size,
                          height: size,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                b.color.withOpacity(b.opacity),
                                Colors.transparent,
                              ],
                              radius: 0.8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),

                // 🌫 Global diffusion layer
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                  child: Container(color: Colors.white.withOpacity(0.05)),
                ),

                // 🌟 Foreground content
                widget.child,
              ],
            );
          },
        );
      },
    );
  }
}

class _Bubble {
  final AnimationController controller;
  final Offset startOffset;
  final Color color;
  final double sizeFactor;
  final double opacity;
  final double speed;
  final double blurSigma;

  _Bubble({
    required this.controller,
    required this.startOffset,
    required this.color,
    required this.sizeFactor,
    required this.opacity,
    required this.speed,
    required this.blurSigma,
  });
}

class SoftColorPalette {
  /// Generate a palette of distinct but soft gradient colors
  /// derived from a base theme color.
  static List<Color> generateSoftPalette(Color baseColor, {int count = 6}) {
    final hsl = HSLColor.fromColor(baseColor);
    final random = Random();

    return List.generate(count, (index) {
      // Wider hue variance: up to ±60 degrees (with some complementary flips)
      double hueShift;
      if (index.isEven) {
        hueShift = (random.nextDouble() * 120) - 60; // complementary range
      } else {
        hueShift = (random.nextDouble() * 60) - 30; // closer to base hue
      }

      // More diverse saturation range (to get subtle vs vibrant contrast)
      final saturation = (hsl.saturation * (0.5 + random.nextDouble() * 0.8))
          .clamp(0.25, 0.8);

      // Random lightness variation (soft pastel range)
      final lightness = (hsl.lightness * (1.2 + random.nextDouble() * 0.5))
          .clamp(0.55, 0.95);

      // Convert back to color
      final color = hsl
          .withHue((hsl.hue + hueShift) % 360)
          .withSaturation(saturation)
          .withLightness(lightness)
          .toColor()
          .withOpacity(0.4 + random.nextDouble() * 0.4);

      return color;
    });
  }
}
