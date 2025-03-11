#!/bin/bash

set -e

# Check if the executable exists
if [ ! -f "./stitcher_test" ]; then
    echo "Error: stitcher_test executable not found. Please run build.sh first."
    exit 1
fi

# Check if test images directory exists
TEST_DIR="./test_images"
if [ ! -d "$TEST_DIR" ]; then
    echo "Creating test images directory..."
    mkdir -p "$TEST_DIR"
    
    # Download some sample images for testing
    echo "Downloading sample images for testing..."
    curl -L "https://raw.githubusercontent.com/opencv/opencv/4.x/samples/data/aloeL.jpg" -o "$TEST_DIR/image1.jpg"
    curl -L "https://raw.githubusercontent.com/opencv/opencv/4.x/samples/data/aloeR.jpg" -o "$TEST_DIR/image2.jpg"
fi

# Run the stitcher test
echo "Running stitcher test..."
./stitcher_test "[$TEST_DIR/image1.jpg, $TEST_DIR/image2.jpg]" "$TEST_DIR/output.jpg"

# Check if the output image was created
if [ -f "$TEST_DIR/output.jpg" ]; then
    echo "Test completed successfully. Output image saved to $TEST_DIR/output.jpg"
    
    # Open the image if on macOS
    if [ "$(uname)" == "Darwin" ]; then
        open "$TEST_DIR/output.jpg"
    fi
else
    echo "Test failed. Output image not created."
    exit 1
fi 