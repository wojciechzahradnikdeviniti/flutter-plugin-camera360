import 'package:flutter/material.dart';
import 'package:camera_360/models/stitcher_settings.dart';
import 'package:camera_360/models/enums/enums.dart';

/// A widget that displays and allows editing of stitcher settings
class StitcherSettingsPanel extends StatefulWidget {
  /// Current stitcher settings
  final StitcherSettings settings;

  /// Callback when settings are changed
  final Function(StitcherSettings) onSettingsChanged;

  /// Creates a new [StitcherSettingsPanel]
  const StitcherSettingsPanel({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
  });

  @override
  State<StitcherSettingsPanel> createState() => _StitcherSettingsPanelState();
}

class _StitcherSettingsPanelState extends State<StitcherSettingsPanel> {
  late StitcherSettings _currentSettings;

  @override
  void initState() {
    super.initState();
    _currentSettings = widget.settings;
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
              'Stitcher Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Confidence Threshold
            _buildSliderSetting(
              title: 'Confidence Threshold',
              subtitle:
                  'Higher values result in fewer but more reliable matches',
              value: _currentSettings.confidenceThreshold,
              min: 0.1,
              max: 1.0,
              divisions: 9,
              onChanged: (value) {
                setState(() {
                  _currentSettings = _currentSettings.copyWith(
                    confidenceThreshold: value,
                  );
                });
                widget.onSettingsChanged(_currentSettings);
              },
            ),

            // Panorama Confidence Threshold
            _buildSliderSetting(
              title: 'Panorama Confidence Threshold',
              subtitle: 'Higher values make the stitcher more selective',
              value: _currentSettings.panoConfidenceThresh,
              min: 0.1,
              max: 2.0,
              divisions: 19,
              onChanged: (value) {
                setState(() {
                  _currentSettings = _currentSettings.copyWith(
                    panoConfidenceThresh: value,
                  );
                });
                widget.onSettingsChanged(_currentSettings);
              },
            ),

            // Wave Correction Type
            _buildDropdownSetting<WaveCorrectionType>(
              title: 'Wave Correction',
              subtitle: 'Controls how wave effect correction is applied',
              value: _currentSettings.waveCorrection,
              items: WaveCorrectionType.values,
              itemBuilder: (type) {
                switch (type) {
                  case WaveCorrectionType.none:
                    return 'None';
                  case WaveCorrectionType.horizontal:
                    return 'Horizontal (default)';
                  case WaveCorrectionType.vertical:
                    return 'Vertical';
                }
              },
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _currentSettings = _currentSettings.copyWith(
                      waveCorrection: value,
                    );
                  });
                  widget.onSettingsChanged(_currentSettings);
                }
              },
            ),

            // Exposure Compensator Type
            _buildDropdownSetting<ExposureCompensatorType>(
              title: 'Exposure Compensator',
              subtitle: 'Method used to balance exposure between images',
              value: _currentSettings.exposureCompensator,
              items: ExposureCompensatorType.values,
              itemBuilder: (type) {
                switch (type) {
                  case ExposureCompensatorType.none:
                    return 'None';
                  case ExposureCompensatorType.gain:
                    return 'Gain';
                  case ExposureCompensatorType.gainBlocks:
                    return 'Gain Blocks (default)';
                }
              },
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _currentSettings = _currentSettings.copyWith(
                      exposureCompensator: value,
                    );
                  });
                  widget.onSettingsChanged(_currentSettings);
                }
              },
            ),

            // Registration Resolution
            _buildSliderSetting(
              title: 'Registration Resolution',
              subtitle: 'Resolution for image registration in megapixels',
              value: _currentSettings.registrationResol,
              min: 0.1,
              max: 1.0,
              divisions: 9,
              onChanged: (value) {
                setState(() {
                  _currentSettings = _currentSettings.copyWith(
                    registrationResol: value,
                  );
                });
                widget.onSettingsChanged(_currentSettings);
              },
            ),

            // Use Best Of 2 Nearest Matcher
            _buildDropdownSetting<FeatureMatcherType>(
              title: 'Feature Matcher',
              subtitle: 'Improves feature matching quality',
              value: _currentSettings.featureMatcherType,
              items: FeatureMatcherType.values,
              itemBuilder: (method) {
                switch (method) {
                  case FeatureMatcherType.homography:
                    return 'Homography (default)';
                  case FeatureMatcherType.affine:
                    return 'Affine (better for parallel cameras)';
                }
              },
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _currentSettings = _currentSettings.copyWith(
                      featureMatcherType: value,
                    );
                  });
                  widget.onSettingsChanged(_currentSettings);
                }
              },
            ),

            // Feature Detection Method
            _buildDropdownSetting<FeatureDetectionMethod>(
              title: 'Feature Detection Method',
              subtitle: 'Algorithm used to detect features in images',
              value: _currentSettings.featureDetectionMethod,
              items: FeatureDetectionMethod.values,
              itemBuilder: (method) {
                switch (method) {
                  case FeatureDetectionMethod.sift:
                    return 'SIFT (high quality)';
                  case FeatureDetectionMethod.akaze:
                    return 'AKAZE (good balance)';
                  case FeatureDetectionMethod.orb:
                    return 'ORB (fastest)';
                }
              },
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _currentSettings = _currentSettings.copyWith(
                      featureDetectionMethod: value,
                    );
                  });
                  widget.onSettingsChanged(_currentSettings);
                }
              },
            ),

            // Feature Matcher Image Range
            _buildNumberInputSetting(
              title: 'Feature Matcher Image Range',
              subtitle:
                  'Limits the number of images to match with each other. Set to -1 to match with all images, or a positive value (e.g., 3) to match only with that many nearby images.',
              value: _currentSettings.featureMatcherImageRange,
              onChanged: (value) {
                setState(() {
                  _currentSettings = _currentSettings.copyWith(
                    featureMatcherImageRange: value,
                  );
                });
                widget.onSettingsChanged(_currentSettings);
              },
            ),

            // Blender Type
            _buildDropdownSetting<BlenderType>(
              title: 'Blender Type',
              subtitle: 'Method used to blend images together',
              value: _currentSettings.blenderType,
              items: BlenderType.values,
              itemBuilder: (type) {
                switch (type) {
                  case BlenderType.none:
                    return 'None (no blending)';
                  case BlenderType.feather:
                    return 'Feather (simple blending)';
                  case BlenderType.multiband:
                    return 'Multiband (best quality, default)';
                }
              },
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _currentSettings = _currentSettings.copyWith(
                      blenderType: value,
                    );
                  });
                  widget.onSettingsChanged(_currentSettings);
                }
              },
            ),

            const SizedBox(height: 16),

            // Reset button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentSettings = const StitcherSettings();
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
                label: value.toStringAsFixed(2),
                onChanged: onChanged,
              ),
            ),
            Container(
              width: 50,
              alignment: Alignment.center,
              child: Text(
                value.toStringAsFixed(2),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        const Divider(color: Colors.white24),
      ],
    );
  }

  // ignore: unused_element
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

  Widget _buildDropdownSetting<T>({
    required String title,
    required String subtitle,
    required T value,
    required List<T> items,
    required String Function(T) itemBuilder,
    required ValueChanged<T?> onChanged,
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
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white24),
          ),
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
            dropdownColor: Colors.black87,
            underline: const SizedBox(),
            style: const TextStyle(color: Colors.white),
            items: items.map((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(itemBuilder(item)),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 8),
        const Divider(color: Colors.white24),
      ],
    );
  }

  Widget _buildNumberInputSetting({
    required String title,
    required String subtitle,
    required int value,
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
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            // Minus button
            IconButton(
              icon:
                  const Icon(Icons.remove_circle_outline, color: Colors.white),
              onPressed: () {
                final newValue = value - 1;
                controller.text = newValue.toString();
                onChanged(newValue);
              },
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
                      onChanged(newValue);
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
              onPressed: () {
                final newValue = value + 1;
                controller.text = newValue.toString();
                onChanged(newValue);
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(color: Colors.white24),
      ],
    );
  }
}
