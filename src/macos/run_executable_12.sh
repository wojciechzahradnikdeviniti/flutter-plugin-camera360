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
./stitcher_test "[\
$TEST_DIR/12/1.jpg,\
$TEST_DIR/12/2.jpg,\
$TEST_DIR/12/3.jpg,\
$TEST_DIR/12/4.jpg,\
$TEST_DIR/12/5.jpg,\
$TEST_DIR/12/6.jpg,\
$TEST_DIR/12/7.jpg,\
$TEST_DIR/12/8.jpg,\
$TEST_DIR/12/9.jpg,\
$TEST_DIR/12/10.jpg,\
$TEST_DIR/12/11.jpg,\
$TEST_DIR/12/12.jpg\
]" \
"$TEST_DIR/output.jpg" \
--cropped=true \
--feature-detection=1 \
--confidence=0.25 \
--pano-confidence=0.7 \
--wave-correction=1 \
--registration-resol=0.8 \
--matcher-type=0 \
--feature-matcher-range=-1 \
--blender-type=2

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