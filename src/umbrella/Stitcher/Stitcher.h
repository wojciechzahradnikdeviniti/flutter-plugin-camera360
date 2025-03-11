#include <stdbool.h>

#ifdef __cplusplus
extern "C"
{
#endif

    // Shared declaration
    bool stitch(char *inputImagePath, char *outputImagePath, bool cropped,
                double confidenceThreshold, double panoConfidenceThresh,
                int waveCorrection,
                double registrationResol, int featureMatcherType,
                int featureDetectionMethod, int featureMatcherImageRange,
                int blenderType);

#ifdef __cplusplus
} // closing brace for extern "C"
#endif