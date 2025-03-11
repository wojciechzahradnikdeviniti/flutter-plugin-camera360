import 'package:camera_360/camera_360.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'widgets/stitcher_settings_panel.dart';
import 'widgets/settings_toggle_button.dart';
import 'widgets/panorama_preview_dialog.dart';
import 'widgets/reset_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('360 Camera App'),
        ),
        body: const CameraPage(),
      ),
    );
  }
}

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  int progressPercentage = 0;
  bool isSettingsVisible = false;
  // Key to force rebuild of Camera360 widget
  Key _cameraKey = UniqueKey();

  // Optimized for indoor use
  StitcherSettings stitcherSettings = const StitcherSettings(
    confidenceThreshold: 0.25,
    panoConfidenceThresh: 0.7,
    waveCorrection: WaveCorrectionType.horizontal,
    registrationResol: 0.8,
    featureMatcherType: FeatureMatcherType.homography,
    featureDetectionMethod: FeatureDetectionMethod.akaze,
    featureMatcherImageRange: -1,
    blenderType: BlenderType.multiband,
  );

  void _toggleSettingsVisibility() {
    setState(() {
      isSettingsVisible = !isSettingsVisible;
    });
  }

  void _updateSettings(StitcherSettings newSettings) {
    setState(() {
      stitcherSettings = newSettings;
    });
  }

  void _resetCamera() {
    // Reset the camera by recreating the Camera360 widget with a new key
    setState(() {
      progressPercentage = 0;
      // Create a new key to force rebuild
      _cameraKey = UniqueKey();
    });

    // Display a message to the user
    displayPanoramaMessage(context, 'Camera reset');
  }

  // Helper method to display messages
  void displayPanoramaMessage(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Camera360(
          key: _cameraKey,
          userNrPhotos: 12,
          // Determines when image stitching is performed.
          // If set to true, the application will check if each newly captured image
          // can be stitched with the previous one immediately after capture.
          // If set to false, all images will be captured first,
          // and stitching will be performed at the end.
          userCheckStitchingDuringCapture: false,
          // Text shown while panorama image is being prepared
          userLoadingText: "Preparing panorama...",
          // Text shown on while taking the first image
          userHelperText: "Point the camera at the dot",
          // Text shown when user should tilt the device to the left
          userHelperTiltLeftText: "Tilt left",
          // Text shown when user should tilt the device to the right
          userHelperTiltRightText: "Tilt Right",
          // Suggested key for iPhone >= 11 is 2 to select the wide-angle camera
          // On android devices 0 is suggested as at the moment Camera switching is not possible on android
          userSelectedCameraKey: 2,
          // Camera selector Visibilitiy
          cameraSelectorShow: true,
          // Camera selector Info Visibilitiy
          cameraSelectorInfoPopUpShow: true,
          // Custom stitcher settings
          stitcherSettings: stitcherSettings,
          // Camera selector Info Widget
          cameraSelectorInfoPopUpContent: const Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "Notice: This feature only works if your phone has a wide angle camera.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xffDB4A3C),
                  ),
                ),
              ),
              Text(
                "Select the camera with the widest viewing angle below.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xffEFEFEF),
                ),
              ),
            ],
          ),
          // Callback function called when 360 capture ended
          onCaptureEnded: (data) {
            if (data['success'] == true) {
              // Save image to the gallery
              XFile panorama = data['panorama'];
              GallerySaver.saveImage(panorama.path);

              // Show preview dialog
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) => PanoramaPreviewDialog(
                  panorama: panorama,
                ),
              );

              displayPanoramaMessage(context, 'Panorama saved!');
            } else {
              displayPanoramaMessage(context, 'Panorama failed!');
            }
          },
          // Callback function called when the camera lens is changed
          onCameraChanged: (cameraKey) {
            displayPanoramaMessage(
                context, "Camera changed ${cameraKey.toString()}");
          },
          // Callback function called when capture progress is changed
          onProgressChanged: (newProgressPercentage) {
            debugPrint(
                "'Panorama360': Progress changed: $newProgressPercentage");
            // Use addPostFrameCallback to avoid calling setState during build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  progressPercentage = newProgressPercentage;
                });
              }
            });
          },
        ),

        // Progress indicator
        Positioned(
          top: 20,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Progress: $progressPercentage%",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),

        // Settings toggle button
        Positioned(
          bottom: 20,
          right: 20,
          child: SettingsToggleButton(
            isSettingsVisible: isSettingsVisible,
            onPressed: _toggleSettingsVisibility,
          ),
        ),

        // Reset button
        Positioned(
          bottom: 20,
          left: 20,
          child: ResetButton(
            onPressed: _resetCamera,
          ),
        ),

        // Settings panel
        if (isSettingsVisible)
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: StitcherSettingsPanel(
              settings: stitcherSettings,
              onSettingsChanged: _updateSettings,
            ),
          ),
      ],
    );
  }
}
