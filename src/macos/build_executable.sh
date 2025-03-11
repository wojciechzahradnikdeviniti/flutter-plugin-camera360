#!/bin/bash

set -e

# Create build directory
mkdir -p build
cd build

# Configure with CMake
cmake ..

# Build
make

# Copy executable to parent directory
cp stitcher_test ..

echo "Build completed successfully. Executable is at src/macos/stitcher_test" 