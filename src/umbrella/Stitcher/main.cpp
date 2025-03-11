#include "Stitcher.h"
#include <iostream>
#include <string>
#include <vector>

void printUsage()
{
  std::cout << "Usage: stitcher_test <input_images_list> <output_image_path> [options]" << std::endl;
  std::cout << "Options:" << std::endl;
  std::cout << "  --cropped=<true|false>                 Whether to crop the result (default: true)" << std::endl;
  std::cout << "  --confidence=<threshold>               Confidence threshold (default: 0.3)" << std::endl;
  std::cout << "  --pano-confidence=<threshold>          Panorama confidence threshold (default: 1.0)" << std::endl;
  std::cout << "  --wave-correction=<0|1|2>              Wave correction (0=None, 1=Horizontal, 2=Vertical, default: 1)" << std::endl;
  std::cout << "  --registration-resol=<resolution>      Registration resolution (default: 0.6)" << std::endl;
  std::cout << "  --matcher-type=<0|1>                   Matcher type (0=Homography, 1=Affine, default: 0)" << std::endl;
  std::cout << "  --feature-detection=<0|1|2>            Feature detection method (0=SIFT, 1=AKAZE, 2=ORB, default: 2)" << std::endl;
  std::cout << "  --feature-matcher-range=<range>        Feature matcher image range (default: 1)" << std::endl;
  std::cout << "  --blender-type=<0|1|2>                 Blender type (0=None, 1=Feather, 2=Multiband, default: 2)" << std::endl;
}

std::string getOptionValue(const std::string &option, int argc, char *argv[], const std::string &defaultValue)
{
  for (int i = 3; i < argc; i++)
  {
    std::string arg = argv[i];
    if (arg.find(option + "=") == 0)
    {
      return arg.substr(option.length() + 1);
    }
  }
  return defaultValue;
}

bool getBoolOption(const std::string &option, int argc, char *argv[], bool defaultValue)
{
  std::string value = getOptionValue(option, argc, argv, defaultValue ? "true" : "false");
  return value == "true" || value == "1";
}

int getIntOption(const std::string &option, int argc, char *argv[], int defaultValue)
{
  std::string value = getOptionValue(option, argc, argv, std::to_string(defaultValue));
  return std::stoi(value);
}

double getDoubleOption(const std::string &option, int argc, char *argv[], double defaultValue)
{
  std::string value = getOptionValue(option, argc, argv, std::to_string(defaultValue));
  return std::stod(value);
}

int main(int argc, char *argv[])
{
  if (argc < 3)
  {
    printUsage();
    return 1;
  }

  char *inputImagePath = argv[1];
  char *outputImagePath = argv[2];

  // Parse options
  bool cropped = getBoolOption("--cropped", argc, argv, true);
  double confidenceThreshold = getDoubleOption("--confidence", argc, argv, 0.3);
  double panoConfidenceThresh = getDoubleOption("--pano-confidence", argc, argv, 1.0);
  int waveCorrection = getIntOption("--wave-correction", argc, argv, 1);
  double registrationResol = getDoubleOption("--registration-resol", argc, argv, 0.6);
  int matcherType = getIntOption("--matcher-type", argc, argv, 0);
  int featureDetectionMethod = getIntOption("--feature-detection", argc, argv, 2);
  int featureMatcherImageRange = getIntOption("--feature-matcher-range", argc, argv, 1);
  int blenderType = getIntOption("--blender-type", argc, argv, 2);

  // Print the parameters
  std::cout << "Input images: " << inputImagePath << std::endl;
  std::cout << "Output image: " << outputImagePath << std::endl;
  std::cout << "Cropped: " << (cropped ? "true" : "false") << std::endl;
  std::cout << "Confidence threshold: " << confidenceThreshold << std::endl;
  std::cout << "Panorama confidence threshold: " << panoConfidenceThresh << std::endl;
  std::cout << "Wave correction: " << waveCorrection << std::endl;
  std::cout << "Registration resolution: " << registrationResol << std::endl;
  std::cout << "Matcher type: " << matcherType << std::endl;
  std::cout << "Feature detection method: " << featureDetectionMethod << std::endl;
  std::cout << "Feature matcher image range: " << featureMatcherImageRange << std::endl;
  std::cout << "Blender type: " << blenderType << std::endl;

  // Call the stitch function
  bool result = stitch(
      inputImagePath,
      outputImagePath,
      cropped,
      confidenceThreshold,
      panoConfidenceThresh,
      waveCorrection,
      registrationResol,
      matcherType,
      featureDetectionMethod,
      featureMatcherImageRange,
      blenderType);

  if (result)
  {
    std::cout << "Stitching completed successfully!" << std::endl;
    return 0;
  }
  else
  {
    std::cout << "Stitching failed!" << std::endl;
    return 1;
  }
}