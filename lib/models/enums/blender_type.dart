/// Enum for blender types used in panorama stitching
enum BlenderType {
  /// No blending
  none(0),

  /// Feather blending
  feather(1),

  /// Multiband blending (default)
  multiband(2);

  /// The integer value of the enum
  final int value;

  /// Constructor
  const BlenderType(this.value);

  /// Create a BlenderType from an integer value
  static BlenderType fromValue(int value) {
    return BlenderType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => BlenderType.multiband,
    );
  }
}
