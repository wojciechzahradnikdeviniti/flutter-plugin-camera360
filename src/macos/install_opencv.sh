#!/bin/bash

set -e

OPENCV_VERSION=${1:-4.8.0}

# Check if OpenCV is already installed
if brew list opencv > /dev/null 2>&1; then
    echo "OpenCV is already installed via Homebrew."
    brew info opencv
    exit 0
fi

echo "Installing OpenCV ${OPENCV_VERSION} via Homebrew..."

# Install Homebrew if not installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install OpenCV
brew install opencv

echo "OpenCV installation completed." 