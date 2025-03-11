#!/bin/bash

set -e

# Check if the executable exists
if [ ! -f "./stitcher_test" ]; then
    echo "Error: stitcher_test executable not found. Please run build.sh first."
    exit 1
fi

# Check if test images directory exists
TEST_DIR="./test_images"

# Run the stitcher test
echo "Running stitcher test..."
./stitcher_test "[$TEST_DIR/6/1.jpg, $TEST_DIR/6/2.jpg, $TEST_DIR/6/3.jpg, $TEST_DIR/6/4.jpg, $TEST_DIR/6/5.jpg, $TEST_DIR/6/6.jpg]" "$TEST_DIR/output.jpg" --cropped=true --feature-detection=2 --confidence=0.3 --pano-confidence=1 --wave-correction=1 --registration-resol=1 --matcher-type=0 --feature-matcher-range=-1

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