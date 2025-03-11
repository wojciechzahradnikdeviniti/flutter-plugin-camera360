/// The type of feature matcher to use for image stitching
enum FeatureMatcherType {
  /// Uses homography transformation for matching (default)
  /// Best for general purpose stitching
  homography(0),

  /// Uses affine transformation for matching
  /// Better for scenes captured with parallel cameras
  affine(1);

  /// The integer value used in the native code
  final int value;

  /// Constructor for enum values with their corresponding integer values
  const FeatureMatcherType(this.value);

  /// Create an enum from a value received from native code
  static FeatureMatcherType fromValue(int value) {
    switch (value) {
      case 1:
        return FeatureMatcherType.affine;
      case 0:
      default:
        return FeatureMatcherType.homography;
    }
  }
}
