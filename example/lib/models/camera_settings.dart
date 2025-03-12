import 'package:flutter/foundation.dart';

/// Model class to hold camera settings
class CameraSettings {
  /// Vertical correction angle in degrees
  final double deviceVerticalCorrectDeg;

  /// Captured image quality (0-100)
  final int capturedImageQuality;

  /// Captured image width in pixels
  final int capturedImageWidth;

  /// Number of photos to take for the panorama
  final int nrPhotos;

  /// Whether to check stitching during capture
  final bool checkStitchingDuringCapture;

  /// Camera key to use (0, 1, 2, etc.)
  final int selectedCameraKey;

  /// Whether to show camera selector
  final bool cameraSelectorShow;

  /// Whether to show camera selector info popup
  final bool cameraSelectorInfoPopUpShow;

  /// Text shown while panorama image is being prepared
  final String loadingText;

  /// Text shown while taking the first image
  final String helperText;

  /// Text shown when user should tilt the device to the left
  final String helperTiltLeftText;

  /// Text shown when user should tilt the device to the right
  final String helperTiltRightText;

  /// Creates a new [CameraSettings] instance
  const CameraSettings({
    this.deviceVerticalCorrectDeg = 75.0,
    this.capturedImageQuality = 100,
    this.capturedImageWidth = 1000,
    this.nrPhotos = 12,
    this.checkStitchingDuringCapture = false,
    this.selectedCameraKey = 2,
    this.cameraSelectorShow = true,
    this.cameraSelectorInfoPopUpShow = true,
    this.loadingText = "Preparing panorama...",
    this.helperText = "Point the camera at the dot",
    this.helperTiltLeftText = "Tilt left",
    this.helperTiltRightText = "Tilt right",
  });

  /// Creates a copy of this [CameraSettings] but with the given fields replaced with the new values
  CameraSettings copyWith({
    double? deviceVerticalCorrectDeg,
    int? capturedImageQuality,
    int? capturedImageWidth,
    int? nrPhotos,
    bool? checkStitchingDuringCapture,
    int? selectedCameraKey,
    bool? cameraSelectorShow,
    bool? cameraSelectorInfoPopUpShow,
    String? loadingText,
    String? helperText,
    String? helperTiltLeftText,
    String? helperTiltRightText,
  }) {
    return CameraSettings(
      deviceVerticalCorrectDeg:
          deviceVerticalCorrectDeg ?? this.deviceVerticalCorrectDeg,
      capturedImageQuality: capturedImageQuality ?? this.capturedImageQuality,
      capturedImageWidth: capturedImageWidth ?? this.capturedImageWidth,
      nrPhotos: nrPhotos ?? this.nrPhotos,
      checkStitchingDuringCapture:
          checkStitchingDuringCapture ?? this.checkStitchingDuringCapture,
      selectedCameraKey: selectedCameraKey ?? this.selectedCameraKey,
      cameraSelectorShow: cameraSelectorShow ?? this.cameraSelectorShow,
      cameraSelectorInfoPopUpShow:
          cameraSelectorInfoPopUpShow ?? this.cameraSelectorInfoPopUpShow,
      loadingText: loadingText ?? this.loadingText,
      helperText: helperText ?? this.helperText,
      helperTiltLeftText: helperTiltLeftText ?? this.helperTiltLeftText,
      helperTiltRightText: helperTiltRightText ?? this.helperTiltRightText,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CameraSettings &&
        other.deviceVerticalCorrectDeg == deviceVerticalCorrectDeg &&
        other.capturedImageQuality == capturedImageQuality &&
        other.capturedImageWidth == capturedImageWidth &&
        other.nrPhotos == nrPhotos &&
        other.checkStitchingDuringCapture == checkStitchingDuringCapture &&
        other.selectedCameraKey == selectedCameraKey &&
        other.cameraSelectorShow == cameraSelectorShow &&
        other.cameraSelectorInfoPopUpShow == cameraSelectorInfoPopUpShow &&
        other.loadingText == loadingText &&
        other.helperText == helperText &&
        other.helperTiltLeftText == helperTiltLeftText &&
        other.helperTiltRightText == helperTiltRightText;
  }

  @override
  int get hashCode => Object.hash(
        deviceVerticalCorrectDeg,
        capturedImageQuality,
        capturedImageWidth,
        nrPhotos,
        checkStitchingDuringCapture,
        selectedCameraKey,
        cameraSelectorShow,
        cameraSelectorInfoPopUpShow,
        loadingText,
        helperText,
        helperTiltLeftText,
        helperTiltRightText,
      );
}
