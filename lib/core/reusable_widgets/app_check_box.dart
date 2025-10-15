import 'package:flutter/material.dart';

class AppCheckBox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AppCheckBox({super.key, required this.value, required this.onChanged});

  @override
  State<AppCheckBox> createState() => _AppCheckBoxState();
}

class _AppCheckBoxState extends State<AppCheckBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    if (widget.value) _controller.forward();
  }

  @override
  void didUpdateWidget(AppCheckBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      widget.value ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => widget.onChanged(!widget.value),
      child: ScaleTransition(
        scale: _scaleAnimation.drive(Tween(begin: 0.95, end: 1.0)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: widget.value
                ? theme.colorScheme.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: theme.colorScheme.primary, width: 1.6),
            boxShadow: widget.value
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Icon(
                Icons.check_rounded,
                size: 16,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
