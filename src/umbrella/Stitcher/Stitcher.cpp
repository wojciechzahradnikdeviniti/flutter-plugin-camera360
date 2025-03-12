#include "Stitcher.h"

#include "opencv2/opencv.hpp"
#include "opencv2/stitching.hpp"
#include "opencv2/imgproc.hpp"
#include "opencv2/features2d.hpp"
#include "opencv2/stitching/detail/matchers.hpp"

#ifdef __OBJC__
#import <Foundation/Foundation.h>
#endif

using namespace cv;
using namespace std;

// @interface Cropping : NSObject
// + (bool) cropWithMat: (const cv::Mat &)src andResult:(cv::Mat &)dest;
// @end

// CROPPPING STARTS HERES
bool checkBlackRow(const cv::Mat &roi, int y, const cv::Rect &rect)
{
    int zeroCount = 0;
    for (int x = rect.x; x < rect.width; x++)
    {
        if (roi.at<uchar>(y, x) == 0)
        {
            zeroCount++;
        }
    }
    if ((zeroCount / (float)roi.cols) > 0.05)
    {
        return false;
    }
    return true;
}

bool checkBlackColumn(const cv::Mat &roi, int x, const cv::Rect &rect)
{
    int zeroCount = 0;
    for (int y = rect.y; y < rect.height; y++)
    {
        if (roi.at<uchar>(y, x) == 0)
        {
            zeroCount++;
        }
    }
    if ((zeroCount / (float)roi.rows) > 0.05)
    {
        return false;
    }
    return true;
}

bool cropWithMat(const cv::Mat src, cv::Mat &dest)
{
    cv::Mat gray;
    cvtColor(src, gray, cv::COLOR_BGRA2GRAY); // convert src to gray

    cv::Rect roiRect(0, 0, gray.cols, gray.rows); // start as the source image - ROI is the complete SRC-Image

    while (1)
    {
        bool isTopNotBlack = checkBlackRow(gray, roiRect.y, roiRect);
        bool isLeftNotBlack = checkBlackColumn(gray, roiRect.x, roiRect);
        bool isBottomNotBlack = checkBlackRow(gray, roiRect.y + roiRect.height - 1, roiRect);
        bool isRightNotBlack = checkBlackColumn(gray, roiRect.x + roiRect.width - 1, roiRect);

        if (isTopNotBlack && isLeftNotBlack && isBottomNotBlack && isRightNotBlack)
        {
            printf("'Stitcher': Cropped coordinates %d %d %d %d \n", roiRect.x, roiRect.y, roiRect.width, roiRect.height);

            cv::Mat imageReference = src(roiRect);
            imageReference.copyTo(dest);
            return true;
        }
        // If not, scale ROI down
        // if x is increased, width has to be decreased to compensate
        if (!isLeftNotBlack)
        {
            roiRect.x++;
            roiRect.width--;
        }
        // same is valid for y
        if (!isTopNotBlack)
        {
            roiRect.y++;
            roiRect.height--;
        }
        if (!isRightNotBlack)
        {
            roiRect.width--;
        }
        if (!isBottomNotBlack)
        {
            roiRect.height--;
        }
        if (roiRect.width <= 0 || roiRect.height <= 0)
        {
            printf("'Stitcher': Cropping failed");
            return false;
        }
    }
}
// CROPPPING ENDS HERES

struct tokens : ctype<char>
{
    tokens() : std::ctype<char>(get_table()) {}

    static std::ctype_base::mask const *get_table()
    {
        typedef std::ctype<char> cctype;
        static const cctype::mask *const_rc = cctype::classic_table();

        static cctype::mask rc[cctype::table_size];
        std::memcpy(rc, const_rc, cctype::table_size * sizeof(cctype::mask));

        rc[','] = ctype_base::space;
        rc[' '] = ctype_base::space;
        return &rc[0];
    }
};
vector<string> getpathlist(string path_string)
{
    string sub_string = path_string.substr(1, path_string.length() - 2);
    stringstream ss(sub_string);
    ss.imbue(locale(locale(), new tokens()));
    istream_iterator<std::string> begin(ss);
    istream_iterator<std::string> end;
    vector<std::string> pathlist(begin, end);
    return pathlist;
}

vector<Mat> convert_to_matlist(vector<string> img_list, bool isvertical)
{
    vector<Mat> imgVec;
    bool images_exist = true;
    for (auto k = img_list.begin(); k != img_list.end(); ++k)
    {
        String path = *k;
        Mat input = imread(path);
        // Check if image exists
        if (input.empty())
        {
            images_exist = false;
            break;
        }

        Mat newimage;
        // Convert to a 3 channel Mat to use with Stitcher module
        cvtColor(input, newimage, COLOR_BGR2RGB, 3);
        // Reduce the resolution for fast computation
        float scale = 1000.0f / input.rows;
        // resize(newimage, newimage, Size(scale * input.rows, scale * input.cols));
        if (isvertical)
            rotate(newimage, newimage, ROTATE_90_COUNTERCLOCKWISE);
        imgVec.push_back(newimage);
    }
    if (images_exist == false)
    {
        vector<Mat> emptyVector;
        return emptyVector;
    }
    return imgVec;
}

bool stitch(char *inputImagePath, char *outputImagePath, bool cropped,
            double confidenceThreshold, double panoConfidenceThresh,
            int waveCorrection,
            double registrationResol, int matcherType,
            int featureDetectionMethod, int featureMatcherImageRange,
            int blenderType)
{
    string input_path_string = inputImagePath;
    vector<string> image_vector_list = getpathlist(input_path_string);
    vector<Mat> mat_list;
    mat_list = convert_to_matlist(image_vector_list, false);
    // Check if stitching failed
    if (mat_list.empty())
    {
        // Stitching failed because some images didn't exist
        printf("'Stitcher': Stitching failed because some images didn't exist\n");
        return false;
    }

    // Process stitching with custom settings
    Mat result;
    Stitcher::Mode mode = Stitcher::PANORAMA;
    Ptr<Stitcher> stitcher = Stitcher::create(mode);

    // Apply wave correction based on the selected type
    switch (waveCorrection)
    {
    case 0: // None
        stitcher->setWaveCorrection(false);
        break;
    case 1: // Horizontal
        stitcher->setWaveCorrection(true);
        stitcher->setWaveCorrectKind(detail::WAVE_CORRECT_HORIZ);
        printf("'Stitcher': Using Wave Correction: Horizontal\n");
        break;
    case 2: // Vertical
        stitcher->setWaveCorrection(true);
        stitcher->setWaveCorrectKind(detail::WAVE_CORRECT_VERT);
        printf("'Stitcher': Using Wave Correction: Vertical\n");
        break;
    default: // Default to horizontal
        stitcher->setWaveCorrection(true);
        stitcher->setWaveCorrectKind(detail::WAVE_CORRECT_HORIZ);
        printf("'Stitcher': Using Wave Correction: Horizontal\n");
        break;
    }

    // Set registration resolution
    stitcher->setRegistrationResol(registrationResol);

    // Set blender based on the selected type
    switch (blenderType)
    {
    case 0:                                                       // None
        stitcher->setBlender(makePtr<detail::FeatherBlender>(0)); // 0 sharpness means no blending
        printf("'Stitcher': Using FeatherBlender with Sharpness: 0\n");
        break;
    case 1: // Feather
        stitcher->setBlender(makePtr<detail::FeatherBlender>(0.05f));
        printf("'Stitcher': Using FeatherBlender with Sharpness: 0.05\n");
        break;
    case 2: // Multiband
        stitcher->setBlender(makePtr<detail::MultiBandBlender>());
        printf("'Stitcher': Using MultiBandBlender\n");
        break;
    default: // Default to multiband
        stitcher->setBlender(makePtr<detail::MultiBandBlender>());
        printf("'Stitcher': Using MultiBandBlender\n");
        break;
    }

    // Set feature matcher based on type and range width
    float match_conf = confidenceThreshold > 0 ? static_cast<float>(confidenceThreshold) : 0.3f;

    if (mat_list.size() > 2 && featureMatcherImageRange > 0)
    {
        // Use BestOf2NearestRangeMatcher when range width is specified
        stitcher->setFeaturesMatcher(makePtr<detail::BestOf2NearestRangeMatcher>(
            false, match_conf, featureMatcherImageRange));
        printf("'Stitcher': Using BestOf2NearestRangeMatcher feature matcher with Range Width: %d\n", featureMatcherImageRange);
    }
    else if (matcherType == 1)
    { // Affine
        stitcher->setFeaturesMatcher(makePtr<detail::AffineBestOf2NearestMatcher>(
            false, match_conf));
        printf("'Stitcher': Using AffineBestOf2NearestMatcher feature matcher \n");
    }
    else
    { // Homography (default)
        stitcher->setFeaturesMatcher(makePtr<detail::BestOf2NearestMatcher>(
            false, match_conf));
        printf("'Stitcher': Using BestOf2NearestMatcher feature matcher \n");
    }
    printf("'Stitcher': Match Confidence: %f\n", match_conf);

    // Set the confidence threshold for panorama
    // Use the value passed from Dart, or default to 1.0 if not specified
    float conf_thresh = panoConfidenceThresh >= 0 ? static_cast<float>(panoConfidenceThresh) : 1.0f;
    stitcher->setPanoConfidenceThresh(conf_thresh);
    printf("'Stitcher': Using Pano Confidence Threshold: %f\n", conf_thresh);

    // Set feature finder based on the selected method
    // Following the approach from the OpenCV stitching example
    Ptr<Feature2D> finder;
    switch (featureDetectionMethod)
    {
    case 0: // SIFT
        finder = SIFT::create();
        printf("'Stitcher': Using SIFT feature detector\n");
        break;
    case 1: // AKAZE
        finder = AKAZE::create();
        printf("'Stitcher': Using AKAZE feature detector\n");
        break;
    case 2: // ORB
        finder = ORB::create();
        printf("'Stitcher': Using ORB feature detector\n");
        break;
    default:
        // Default to ORB as it's most likely to be available
        finder = ORB::create();
        printf("'Stitcher': Using ORB feature detector\n");
        break;
    }

    // Create a feature finder that uses the selected algorithm
    stitcher->setFeaturesFinder(finder);

    // Handle cv::Exception
    try
    {
        Stitcher::Status status = stitcher->stitch(mat_list, result);
        // If stitching failed
        if (status != Stitcher::OK)
        {
            printf("'Stitcher': Stitching error: %d\n", status);
            return false;
        }

        printf("'Stitcher': Stitching success here\n");
        cvtColor(result, result, COLOR_RGB2BGR);

        if (cropped == true)
        {
            // Crop black background
            Mat withoutBlackBg;
            if (cropWithMat(result, withoutBlackBg) == true)
            {
                imwrite(outputImagePath, withoutBlackBg);
                printf("'Stitcher': Image cropped successfully\n");
                return true;
            }
            else
            {
                printf("'Stitcher': Image cropping failed\n");
                return false;
            }
        }
        else
        {
            Mat cropped_image;
            result(Rect(0, 0, result.cols, result.rows)).copyTo(cropped_image);
            imwrite(outputImagePath, cropped_image);
            return true;
        }
    }
    catch (cv::Exception &e)
    {
        printf("'Stitcher': Stitching error cv::Exception: %s\n", e.err.c_str());
        return false;
    }
}
