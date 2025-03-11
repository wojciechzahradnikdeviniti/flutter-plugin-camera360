/// Enum representing different feature detection methods
///
/// Used to detect features in images for panorama stitching
enum FeatureDetectionMethod {
  /// Scale-Invariant Feature Transform
  ///
  /// Good for general purpose stitching with high accuracy but slower performance.
  /// Note: May not be available in all OpenCV builds, will fall back to ORB if not available.
  sift(0),

  /// Accelerated-KAZE
  ///
  /// Good balance between accuracy and performance
  akaze(1),

  /// Oriented FAST and Rotated BRIEF
  ///
  /// Fastest method but may be less accurate for complex panoramas.
  /// This is the most widely available method across OpenCV builds.
  orb(2);

  /// The integer value used in the native code
  final int value;

  /// Constructor for enum values with their corresponding integer values
  const FeatureDetectionMethod(this.value);

  /// Get an enum value from its integer representation
  static FeatureDetectionMethod fromValue(int value) {
    return FeatureDetectionMethod.values.firstWhere(
      (method) => method.value == value,
      orElse: () => FeatureDetectionMethod
          .orb, // Default to ORB if not found as it's most widely available
    );
  }
}
