# Stitcher Test for macOS

This is a macOS executable for testing the Stitcher functionality.

## Prerequisites

- macOS
- CMake (version 3.21 or higher)
- OpenCV (version 4.8.0 or compatible)

## Installation

### Install OpenCV

You can install OpenCV using the provided script:

```bash
./install_opencv.sh
```

This will install OpenCV using Homebrew.

### Build the Executable

To build the executable, run:

```bash
./build_executable.sh
```

This will create an executable named `stitcher_test` in the current directory.

## Usage

```bash
./stitcher_test <input_images_list> <output_image_path> [options]
```

Use the run_executable.sh to run a test example with some test values

```bash
./run_executable.sh
```

### Parameters

- `input_images_list`: A string containing a comma-separated list of image paths, enclosed in square brackets. For example: `"[/path/to/image1.jpg, /path/to/image2.jpg, /path/to/image3.jpg]"`
- `output_image_path`: The path where the stitched image will be saved.

### Options

- `--cropped=<true|false>`: Whether to crop the result (default: true)
- `--confidence=<threshold>`: Confidence threshold (default: 0.3)
- `--pano-confidence=<threshold>`: Panorama confidence threshold (default: 1.0)
- `--wave-correction=<0|1|2>`: Wave correction (0=None, 1=Horizontal, 2=Vertical, default: 1)
- `--registration-resol=<resolution>`: Registration resolution (default: 0.6)
- `--matcher-type=<0|1>`: Matcher type (0=Homography, 1=Affine, default: 0)
- `--feature-detection=<0|1|2>`: Feature detection method (0=SIFT, 1=AKAZE, 2=ORB, default: 2)
- `--feature-matcher-range=<range>`: Feature matcher image range (default: 1)
- `--blender-type=<0|1|2>`: Blender type (0=None, 1=Feather, 2=Multiband, default: 2)

### Example

```bash
./stitcher_test "[/path/to/image1.jpg, /path/to/image2.jpg]" output.jpg --cropped=true --feature-detection=2
``` 