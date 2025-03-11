/// Enum representing different wave correction types
///
/// Used to control wave effect correction in panorama stitching
enum WaveCorrectionType {
  /// No wave correction
  none(0),

  /// Horizontal wave correction (default)
  ///
  /// Corrects the wave effect in horizontal panoramas
  horizontal(1),

  /// Vertical wave correction
  ///
  /// Corrects the wave effect in vertical panoramas
  vertical(2);

  /// The integer value used in the native code
  final int value;

  /// Constructor for enum values with their corresponding integer values
  const WaveCorrectionType(this.value);

  /// Get an enum value from its integer representation
  static WaveCorrectionType fromValue(int value) {
    return WaveCorrectionType.values.firstWhere(
      (type) => type.value == value,
      orElse: () =>
          WaveCorrectionType.horizontal, // Default to horizontal if not found
    );
  }
}
