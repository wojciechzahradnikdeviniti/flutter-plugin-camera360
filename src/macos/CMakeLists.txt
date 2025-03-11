cmake_minimum_required(VERSION 3.21)
project(stitcher_test)

# OpenCV version
set(OPENCV_VERSION 4.8.0)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Paths
set(UMBRELLA_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../umbrella)

# Find OpenCV
find_package(OpenCV 4.8 REQUIRED)
message(STATUS "OpenCV library status:")
message(STATUS "    version: ${OpenCV_VERSION}")
message(STATUS "    libraries: ${OpenCV_LIBS}")
message(STATUS "    include path: ${OpenCV_INCLUDE_DIRS}")

# Source files
set(SOURCES
    ${UMBRELLA_DIR}/Stitcher/Stitcher.cpp
    ${UMBRELLA_DIR}/Stitcher/main.cpp
)

# Include directories
include_directories(
    ${OpenCV_INCLUDE_DIRS}
    ${UMBRELLA_DIR}
)

# Create executable
add_executable(stitcher_test ${SOURCES})

# Link libraries
target_link_libraries(stitcher_test
    ${OpenCV_LIBS}
)

# Install
install(TARGETS stitcher_test DESTINATION bin) 