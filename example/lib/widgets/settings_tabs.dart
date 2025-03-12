import 'package:flutter/material.dart';
import 'package:camera_360/models/stitcher_settings.dart';
import '../models/camera_settings.dart';
import 'camera_settings_panel.dart';
import 'stitcher_settings_panel.dart';

/// A widget that displays tabs to switch between camera and stitcher settings
class SettingsTabs extends StatefulWidget {
  /// Current camera settings
  final CameraSettings cameraSettings;

  /// Current stitcher settings
  final StitcherSettings stitcherSettings;

  /// Callback when camera settings are changed
  final Function(CameraSettings) onCameraSettingsChanged;

  /// Callback when stitcher settings are changed
  final Function(StitcherSettings) onStitcherSettingsChanged;

  /// Creates a new [SettingsTabs]
  const SettingsTabs({
    super.key,
    required this.cameraSettings,
    required this.stitcherSettings,
    required this.onCameraSettingsChanged,
    required this.onStitcherSettingsChanged,
  });

  @override
  State<SettingsTabs> createState() => _SettingsTabsState();
}

class _SettingsTabsState extends State<SettingsTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tab bar
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            tabs: const [
              Tab(
                icon: Icon(Icons.camera_alt),
                text: 'Camera',
              ),
              Tab(
                icon: Icon(Icons.tune),
                text: 'Stitcher',
              ),
            ],
          ),

          // Tab content
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: TabBarView(
              controller: _tabController,
              children: [
                // Camera settings tab
                CameraSettingsPanel(
                  settings: widget.cameraSettings,
                  onSettingsChanged: widget.onCameraSettingsChanged,
                ),

                // Stitcher settings tab
                StitcherSettingsPanel(
                  settings: widget.stitcherSettings,
                  onSettingsChanged: widget.onStitcherSettingsChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
