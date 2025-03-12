import 'package:flutter/material.dart';
import '../models/camera_settings.dart';

/// A widget that displays and allows editing of camera settings
class CameraSettingsPanel extends StatefulWidget {
  /// Current camera settings
  final CameraSettings settings;

  /// Callback when settings are changed
  final Function(CameraSettings) onSettingsChanged;

  /// Creates a new [CameraSettingsPanel]
  const CameraSettingsPanel({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
  });

  @override
  State<CameraSettingsPanel> createState() => _CameraSettingsPanelState();
}

class _CameraSettingsPanelState extends State<CameraSettingsPanel> {
  late CameraSettings _currentSettings;

  // Text controllers for text fields
  late TextEditingController _loadingTextController;
  late TextEditingController _helperTextController;
  late TextEditingController _tiltLeftTextController;
  late TextEditingController _tiltRightTextController;

  @override
  void initState() {
    super.initState();
    _currentSettings = widget.settings;

    // Initialize text controllers
    _loadingTextController =
        TextEditingController(text: _currentSettings.loadingText);
    _helperTextController =
        TextEditingController(text: _currentSettings.helperText);
    _tiltLeftTextController =
        TextEditingController(text: _currentSettings.helperTiltLeftText);
    _tiltRightTextController =
        TextEditingController(text: _currentSettings.helperTiltRightText);
  }

  @override
  void dispose() {
    _loadingTextController.dispose();
    _helperTextController.dispose();
    _tiltLeftTextController.dispose();
    _tiltRightTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.all(16),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Camera Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Vertical Correction Angle
            _buildSliderSetting(
              title: 'Vertical Correction Angle',
              subtitle: 'Angle in degrees to correct vertical alignment',
              value: _currentSettings.deviceVerticalCorrectDeg,
              min: 0,
              max: 180,
              divisions: 18,
              onChanged: (value) {
                setState(() {
                  _currentSettings = _currentSettings.copyWith(
                    deviceVerticalCorrectDeg: value,
                  );
                });
                widget.onSettingsChanged(_currentSettings);
              },
            ),

            // Captured Image Quality
            _buildSliderSetting(
              title: 'Image Quality',
              subtitle: 'Quality of captured images (higher is better)',
              value: _currentSettings.capturedImageQuality.toDouble(),
              min: 10,
              max: 100,
              divisions: 9,
              onChanged: (value) {
                setState(() {
                  _currentSettings = _currentSettings.copyWith(
                    capturedImageQuality: value.round(),
                  );
                });
                widget.onSettingsChanged(_currentSettings);
              },
            ),

            // Captured Image Width
            _buildSliderSetting(
              title: 'Image Width',
              subtitle: 'Width of captured images in pixels',
              value: _currentSettings.capturedImageWidth.toDouble(),
              min: 500,
              max: 4000,
              divisions: 7,
              onChanged: (value) {
                setState(() {
                  _currentSettings = _currentSettings.copyWith(
                    capturedImageWidth: value.round(),
                  );
                });
                widget.onSettingsChanged(_currentSettings);
              },
            ),

            // Number of Photos
            _buildSliderSetting(
              title: 'Number of Photos',
              subtitle: 'Number of photos to take for the panorama',
              value: _currentSettings.nrPhotos.toDouble(),
              min: 4,
              max: 24,
              divisions: 10,
              onChanged: (value) {
                setState(() {
                  _currentSettings = _currentSettings.copyWith(
                    nrPhotos: value.round(),
                  );
                });
                widget.onSettingsChanged(_currentSettings);
              },
            ),

            // Check Stitching During Capture
            _buildSwitchSetting(
              title: 'Check Stitching During Capture',
              subtitle: 'Check if each new image can be stitched immediately',
              value: _currentSettings.checkStitchingDuringCapture,
              onChanged: (value) {
                setState(() {
                  _currentSettings = _currentSettings.copyWith(
                    checkStitchingDuringCapture: value,
                  );
                });
                widget.onSettingsChanged(_currentSettings);
              },
            ),

            // Camera Selector
            _buildSwitchSetting(
              title: 'Show Camera Selector',
              subtitle: 'Allow user to select different camera lenses',
              value: _currentSettings.cameraSelectorShow,
              onChanged: (value) {
                setState(() {
                  _currentSettings = _currentSettings.copyWith(
                    cameraSelectorShow: value,
                  );
                });
                widget.onSettingsChanged(_currentSettings);
              },
            ),

            // Camera Selector Info Popup
            _buildSwitchSetting(
              title: 'Show Camera Selector Info',
              subtitle: 'Show information about camera selection',
              value: _currentSettings.cameraSelectorInfoPopUpShow,
              onChanged: (value) {
                setState(() {
                  _currentSettings = _currentSettings.copyWith(
                    cameraSelectorInfoPopUpShow: value,
                  );
                });
                widget.onSettingsChanged(_currentSettings);
              },
            ),

            // Selected Camera Key
            _buildNumberInputSetting(
              title: 'Selected Camera Key',
              subtitle: 'Camera lens to use (0: main, 1: telephoto, 2: wide)',
              value: _currentSettings.selectedCameraKey,
              min: 0,
              max: 2,
              onChanged: (value) {
                setState(() {
                  _currentSettings = _currentSettings.copyWith(
                    selectedCameraKey: value,
                  );
                });
                widget.onSettingsChanged(_currentSettings);
              },
            ),

            // UI Text Settings
            const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 8),
              child: Text(
                'UI Text Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Loading Text
            _buildTextInputSetting(
              title: 'Loading Text',
              subtitle: 'Text shown while panorama is being prepared',
              controller: _loadingTextController,
              onChanged: (value) {
                setState(() {
                  _currentSettings = _currentSettings.copyWith(
                    loadingText: value,
                  );
                });
                widget.onSettingsChanged(_currentSettings);
              },
            ),

            // Helper Text
            _buildTextInputSetting(
              title: 'Helper Text',
              subtitle: 'Text shown while taking the first image',
              controller: _helperTextController,
              onChanged: (value) {
                setState(() {
                  _currentSettings = _currentSettings.copyWith(
                    helperText: value,
                  );
                });
                widget.onSettingsChanged(_currentSettings);
              },
            ),

            // Tilt Left Text
            _buildTextInputSetting(
              title: 'Tilt Left Text',
              subtitle: 'Text shown when user should tilt left',
              controller: _tiltLeftTextController,
              onChanged: (value) {
                setState(() {
                  _currentSettings = _currentSettings.copyWith(
                    helperTiltLeftText: value,
                  );
                });
                widget.onSettingsChanged(_currentSettings);
              },
            ),

            // Tilt Right Text
            _buildTextInputSetting(
              title: 'Tilt Right Text',
              subtitle: 'Text shown when user should tilt right',
              controller: _tiltRightTextController,
              onChanged: (value) {
                setState(() {
                  _currentSettings = _currentSettings.copyWith(
                    helperTiltRightText: value,
                  );
                });
                widget.onSettingsChanged(_currentSettings);
              },
            ),

            const SizedBox(height: 16),

            // Reset button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentSettings = const CameraSettings();

                    // Update text controllers
                    _loadingTextController.text = _currentSettings.loadingText;
                    _helperTextController.text = _currentSettings.helperText;
                    _tiltLeftTextController.text =
                        _currentSettings.helperTiltLeftText;
                    _tiltRightTextController.text =
                        _currentSettings.helperTiltRightText;
                  });
                  widget.onSettingsChanged(_currentSettings);
                },
                child: const Text('Reset to Defaults'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderSetting({
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: divisions,
                label: value.round().toString(),
                onChanged: onChanged,
              ),
            ),
            Container(
              width: 50,
              alignment: Alignment.center,
              child: Text(
                value.round().toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        const Divider(color: Colors.white24),
      ],
    );
  }

  Widget _buildSwitchSetting({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Enable',
              style: TextStyle(color: Colors.white),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
            ),
          ],
        ),
        const Divider(color: Colors.white24),
      ],
    );
  }

  Widget _buildNumberInputSetting({
    required String title,
    required String subtitle,
    required int value,
    required int min,
    required int max,
    required ValueChanged<int> onChanged,
  }) {
    final TextEditingController controller =
        TextEditingController(text: value.toString());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            // Minus button
            IconButton(
              icon:
                  const Icon(Icons.remove_circle_outline, color: Colors.white),
              onPressed: value > min
                  ? () {
                      final newValue = value - 1;
                      controller.text = newValue.toString();
                      onChanged(newValue);
                    }
                  : null,
            ),
            // Text field
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white24),
                ),
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  onChanged: (text) {
                    if (text.isEmpty) return;
                    try {
                      final newValue = int.parse(text);
                      if (newValue >= min && newValue <= max) {
                        onChanged(newValue);
                      } else {
                        // Reset to previous value if out of range
                        controller.text = value.toString();
                      }
                    } catch (e) {
                      // Reset to previous value if not a valid number
                      controller.text = value.toString();
                    }
                  },
                ),
              ),
            ),
            // Plus button
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              onPressed: value < max
                  ? () {
                      final newValue = value + 1;
                      controller.text = newValue.toString();
                      onChanged(newValue);
                    }
                  : null,
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(color: Colors.white24),
      ],
    );
  }

  Widget _buildTextInputSetting({
    required String title,
    required String subtitle,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white24),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 8),
        const Divider(color: Colors.white24),
      ],
    );
  }
}
