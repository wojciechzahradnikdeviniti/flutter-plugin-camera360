import 'enums/enums.dart';

/// Model class for stitcher settings
class StitcherSettings {
  /// Confidence threshold for feature matching
  /// Default is 0.3
  ///
  /// This parameter controls how strict the feature matcher should be when
  /// matching features between images. Higher values result in fewer but more
  /// reliable matches.
  final double confidenceThreshold;

  /// Confidence threshold for panorama stitching
  /// Default is 1.0
  ///
  /// This parameter determines the threshold for considering if two images
  /// belong to the same panorama. Higher values make the stitcher more
  /// selective about which images to include in the panorama.
  final double panoConfidenceThresh;

  /// Wave correction type
  /// Default is horizontal
  ///
  /// Controls how wave effect correction is applied:
  /// - none: No wave correction
  /// - horizontal: Corrects wave effect in horizontal panoramas (default)
  /// - vertical: Corrects wave effect in vertical panoramas
  final WaveCorrectionType waveCorrection;

  /// Type of exposure compensator
  /// Default is gain_blocks
  final ExposureCompensatorType exposureCompensator;

  /// Registration resolution in megapixels
  /// Default is 0.6 Mpx
  final double registrationResol;

  /// Type of feature matcher to use
  final FeatureMatcherType featureMatcherType;

  /// Feature detection method
  /// Default is ORB
  final FeatureDetectionMethod featureDetectionMethod;

  /// Image range width for feature matching
  /// Limits the number of images to match with each other
  /// Default is -1 (match with all images)
  /// Set to a positive value (e.g., 3) to match only with that many nearby images
  /// If set to a positive value, the feature matcher will use the BestOf2NearestRangeMatcher
  final int featureMatcherImageRange;

  /// Blending method used to combine images
  /// Default is multiband
  ///
  /// Controls how images are blended together:
  /// - none: No blending
  /// - feather: Feather blending
  /// - multiband: Multiband blending (default, best quality)
  final BlenderType blenderType;

  /// Creates a new instance of [StitcherSettings] with default values
  const StitcherSettings({
    this.confidenceThreshold = 0.3,
    this.panoConfidenceThresh = 1.0,
    this.waveCorrection = WaveCorrectionType.horizontal,
    this.exposureCompensator = ExposureCompensatorType.gainBlocks,
    this.registrationResol = 0.6, // Default OpenCV value
    this.featureMatcherType = FeatureMatcherType.homography,
    this.featureDetectionMethod = FeatureDetectionMethod.orb,
    this.featureMatcherImageRange = -1,
    this.blenderType = BlenderType.multiband,
  });

  /// Creates a copy of this [StitcherSettings] with the given fields replaced with new values
  StitcherSettings copyWith({
    double? confidenceThreshold,
    double? panoConfidenceThresh,
    WaveCorrectionType? waveCorrection,
    ExposureCompensatorType? exposureCompensator,
    double? registrationResol,
    FeatureMatcherType? featureMatcherType,
    FeatureDetectionMethod? featureDetectionMethod,
    int? featureMatcherImageRange,
    BlenderType? blenderType,
  }) {
    return StitcherSettings(
      confidenceThreshold: confidenceThreshold ?? this.confidenceThreshold,
      panoConfidenceThresh: panoConfidenceThresh ?? this.panoConfidenceThresh,
      waveCorrection: waveCorrection ?? this.waveCorrection,
      exposureCompensator: exposureCompensator ?? this.exposureCompensator,
      registrationResol: registrationResol ?? this.registrationResol,
      featureMatcherType: featureMatcherType ?? this.featureMatcherType,
      featureDetectionMethod:
          featureDetectionMethod ?? this.featureDetectionMethod,
      featureMatcherImageRange:
          featureMatcherImageRange ?? this.featureMatcherImageRange,
      blenderType: blenderType ?? this.blenderType,
    );
  }

  /// Converts this [StitcherSettings] to a map
  Map<String, dynamic> toMap() {
    return {
      'confidenceThreshold': confidenceThreshold,
      'panoConfidenceThresh': panoConfidenceThresh,
      'waveCorrection': waveCorrection.value,
      'exposureCompensator': exposureCompensator.value,
      'registrationResol': registrationResol,
      'featureMatcherType': featureMatcherType.value,
      'featureDetectionMethod': featureDetectionMethod.value,
      'featureMatcherImageRange': featureMatcherImageRange,
      'blenderType': blenderType.value,
    };
  }

  /// Creates a [StitcherSettings] from a map
  factory StitcherSettings.fromMap(Map<String, dynamic> map) {
    return StitcherSettings(
      confidenceThreshold: map['confidenceThreshold'] ?? 0.65,
      panoConfidenceThresh: map['panoConfidenceThresh'] ?? 1.0,
      waveCorrection: map['waveCorrection'] != null
          ? WaveCorrectionType.fromValue(map['waveCorrection'])
          : WaveCorrectionType.horizontal,
      exposureCompensator: map['exposureCompensator'] != null
          ? ExposureCompensatorType.fromValue(map['exposureCompensator'])
          : ExposureCompensatorType.gainBlocks,
      registrationResol: map['registrationResol'] ?? 0.6,
      featureMatcherType: map['featureMatcherType'] != null
          ? FeatureMatcherType.fromValue(map['featureMatcherType'])
          : FeatureMatcherType.homography,
      featureDetectionMethod: map['featureDetectionMethod'] != null
          ? FeatureDetectionMethod.fromValue(map['featureDetectionMethod'])
          : FeatureDetectionMethod.sift,
      featureMatcherImageRange: map['featureMatcherImageRange'] ?? -1,
      blenderType: map['blenderType'] != null
          ? BlenderType.fromValue(map['blenderType'])
          : BlenderType.multiband,
    );
  }
}
