import 'package:flutter/material.dart';

/// A button that toggles the visibility of the settings panel
class SettingsToggleButton extends StatelessWidget {
  /// Whether the settings panel is currently visible
  final bool isSettingsVisible;

  /// Callback when the button is pressed
  final VoidCallback onPressed;

  /// Creates a new [SettingsToggleButton]
  const SettingsToggleButton({
    super.key,
    required this.isSettingsVisible,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.black.withValues(alpha: 0.7),
      child: Icon(
        isSettingsVisible ? Icons.close : Icons.settings,
        color: Colors.white,
      ),
    );
  }
}
