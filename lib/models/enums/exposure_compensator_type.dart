/// Enum representing different types of exposure compensators
///
/// Used to control how the exposure is balanced across images in a panorama
enum ExposureCompensatorType {
  /// No exposure compensation
  none(0),

  /// Simple gain-based exposure compensation
  gain(1),

  /// Block-based gain compensation
  gainBlocks(2);

  /// The integer value used in the native code
  final int value;

  /// Constructor for enum values with their corresponding integer values
  const ExposureCompensatorType(this.value);

  /// Get an enum value from its integer representation
  static ExposureCompensatorType fromValue(int value) {
    return ExposureCompensatorType.values.firstWhere(
      (type) => type.value == value,
      orElse: () =>
          ExposureCompensatorType.gain, // Default to gain if not found
    );
  }
}
