import 'package:flutter/material.dart';

/// A button that resets the camera view
class ResetButton extends StatelessWidget {
  /// Callback when the button is pressed
  final VoidCallback onPressed;

  /// Creates a new [ResetButton]
  const ResetButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.black.withValues(alpha: 0.7),
      child: const Icon(
        Icons.refresh,
        color: Colors.white,
      ),
    );
  }
}
