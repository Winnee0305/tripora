import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A lightweight iOS-style "ink well" — subtle fade overlay + optional haptic.
class AppInkWell extends StatefulWidget {
  const AppInkWell({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.highlightColor,
    this.overlayOpacity = 0.12,
    this.enableHaptic = true,
    this.duration = const Duration(milliseconds: 120),
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final BorderRadius borderRadius;
  final Color? highlightColor;
  final double overlayOpacity;
  final bool enableHaptic;
  final Duration duration;

  @override
  State<AppInkWell> createState() => _AppInkWellState();
}

class _AppInkWellState extends State<AppInkWell>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (!mounted) return;
    setState(() => _pressed = value);
  }

  void _handleTap() {
    if (widget.enableHaptic) HapticFeedback.selectionClick();
    widget.onTap?.call();
  }

  void _handleLongPress() {
    if (widget.enableHaptic) HapticFeedback.vibrate();
    widget.onLongPress?.call();
  }

  @override
  Widget build(BuildContext context) {
    final overlayColor =
        widget.highlightColor ??
        CupertinoColors.systemGrey.withOpacity(
          0.5,
        ); // base color, opacity controlled separately

    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => Future<void>.delayed(
          const Duration(milliseconds: 60),
          () => _setPressed(false),
        ),
        onTapCancel: () => _setPressed(false),
        onTap: _handleTap,
        onLongPress: widget.onLongPress == null ? null : _handleLongPress,
        child: AnimatedContainer(
          duration: widget.duration,
          curve: Curves.easeOut,
          // A container that holds the child plus an overlay that fades in/out.
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              widget.child,
              // overlay layer
              AnimatedOpacity(
                opacity: _pressed ? widget.overlayOpacity : 0.0,
                duration: widget.duration,
                curve: Curves.easeOut,
                child: Container(color: overlayColor.withOpacity(1.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
