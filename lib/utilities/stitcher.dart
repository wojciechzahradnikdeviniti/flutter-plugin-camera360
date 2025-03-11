import 'dart:ffi';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:camera_360/camera_360_bindings_generated.dart';
import 'package:camera_360/models/stitcher_settings.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class Stitcher {
  // Stitch the images
  static Future<XFile> stitchImages(
    List<XFile> images,
    bool cropped, {
    StitcherSettings? settings,
  }) async {
    // Use default settings if none provided
    settings ??= const StitcherSettings();

    // For Android, you call DynamicLibrary to find and open the shared library
    // You don't need to do this in iOS since all linked symbols map when an app runs.
    final dylib = Platform.isAndroid
        ? DynamicLibrary.open("libcamera_360.so")
        : DynamicLibrary.process();

    List<String> imagePaths = [];
    imagePaths = images.map((imageFile) {
      return imageFile.path;
    }).toList();
    imagePaths.toString().toNativeUtf8();
    debugPrint(imagePaths.toString());

    // Bindings
    final Camera360Bindings bindings = Camera360Bindings(dylib);

    String dirpath =
        "${(await getApplicationDocumentsDirectory()).path}/stitched-panorama-${DateTime.now().millisecondsSinceEpoch}.jpg";

    // Note: confidenceThreshold and panoConfidenceThresh are passed but not used in the C++ code
    // They are kept for API compatibility
    bool isStiched = bindings.stitch(
      imagePaths.toString().toNativeUtf8() as Pointer<Char>,
      dirpath.toNativeUtf8() as Pointer<Char>,
      cropped,
      settings.confidenceThreshold,
      settings.panoConfidenceThresh,
      settings.waveCorrection.value,
      settings.exposureCompensator.value,
      settings.registrationResol,
      settings.featureMatcherType.value,
      settings.featureDetectionMethod.value,
      settings.featureMatcherImageRange,
    );

    if (!isStiched) {
      throw Exception('Stiching failed');
    }

    // Return the stiched image
    return XFile(dirpath);
  }
}
