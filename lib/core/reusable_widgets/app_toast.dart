import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void AppToast(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 100,
      left: MediaQuery.of(context).size.width * 0.1,
      right: MediaQuery.of(context).size.width * 0.1,
      child: _AppToast(message: message),
    ),
  );

  overlay.insert(overlayEntry);

  // Auto-remove after delay
  Future.delayed(const Duration(seconds: 2)).then((_) {
    overlayEntry.remove();
  });
}

class _AppToast extends StatelessWidget {
  final String message;
  const _AppToast({required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: AnimatedOpacity(
        opacity: 1,
        duration: const Duration(milliseconds: 300),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              message,
              style: const TextStyle(
                color: CupertinoColors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
