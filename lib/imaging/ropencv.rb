require 'ropencv'
require 'aws-sdk'
# http://www.ropencv.aduda.eu/examples/
# API search http://www.ropencv.aduda.eu/doc/
module ROpenCV

  include OpenCV


  def get_image_to_temp_file(filename)
    s3 = Aws::S3::Client.new
    resp = s3.get_object(bucket:ENV["AWS_BUCKET"],key:"pans/#{filename}.jpg")
    if resp.content_length
      file = Tempfile.new(  DateTime.now().to_s)
      file.write(resp.body.read)
      file
    else
      nil
    end
  end

  def rem_temp_file(file)
    file.close
    file.unlink
  end

  def extract_face(img_path)
    frame = cv::imread(img_path)
    faces = Std::Vector.new(cv::Rect)
    frame_gray =  cv::Mat.new
    cv::cvt_color(frame,frame_gray, cv::COLOR_BGR2GRAY)
    cv::equalizeHist( frame_gray, frame_gray )
    Rails.FaceCascade.detect_multi_scale( frame_gray, faces, 1.1, 3, )
    # region_of_interest.x = noses[i].x;
    #  region_of_interest.y = noses[i].y;
    #  region_of_interest.width = (noses[i].width);
    #  region_of_interest.height = (noses[i].height);
    if faces.size
      return true
    else
      return false
    end
  end

  def get_mat_gray(img_data){
    gray_image = cv::Mat.new
    cv::cvt_color( img_data, gray_image, cv::COLOR_BGR2GRAY )
    gray_image
  }

  def extract_text(img_path)
     Rails.Tesseract.text_for(img_path).strip
  end

  def attempt_pan_regex(text)
  end

  def run_matches(img_path)
    base = "#{RAILS_ROOT}/public/"
    objs = [
            "emblem.jpg",
            "gandhi.jpg",
            "govt_of_india.jpg",
            "header.jpg",
            "hologram.jpg",
            "it_name.jpg"
           ]
    objs.each |obj| do
      match_keypoints(img_path, "#{base}#{obj}")
    end
  end


  def feature_detect(img_path, ref_path)
    mat1 = cv::imread(img_path,cv::IMREAD_GRAYSCALE)
    mat2 = cv::imread(ref_path,cv::IMREAD_GRAYSCALE)

    if (mat1.empty() || mat2.empty())
      Rails.logger.info("One of the image is missing")
      return false
    end

    detector = cv::FeatureDetector::create("SURF")
    extractor = cv::DescriptorExtractor::create("SURF")


    features1 = Std::Vector.new(cv::KeyPoint)
    features2 = Std::Vector.new(cv::KeyPoint)
    detector.detect mat1,features1
    detector.detect mat2,features2

    descriptor1 = cv::Mat.new
    descriptor2 = cv::Mat.new
    extractor.compute(mat1,features1,descriptor1)
    extractor.compute(mat2,features2,descriptor2)


    matcher = cv::FlannBasedMatcher::create("FlannBased")
    matches = Std::Vector.new(cv::DMatch)
    matcher.match(descriptor1,descriptor2,matches)

    max_dist = 0.0
    min_dist = 100.0
    for i in 0..descriptor1.rows()
      dist = matches[i].get_distance()
      if (dist < min_dist && dist != 0)
        min_dist = dist
      end
      if (dist > max_dist)
        max_dist = dist
      end
    end

    # if(min_dist > 50 )
    #   pp "No match"
    # end
    #
    # threshold = 3 * min_dist
    # threshold2 = 2 * min_dist
    #
    # if (threshold > 75)
    #   threshold = 75
    # elsif (threshold2 >= max_dist)
    #   threshold = min_dist * 1.1
    # elsif (threshold >= max_dist)
    #   threshold = threshold2 * 1.4
    # end

    good_matches = Std::Vector.new(cv::DMatch)
    for i in 0..descriptor1.rows()
      if( matches[i].get_distance() <= max(2*min_dist, 0.02) )
        good_matches.push_back(matches[i])
      end
    end

    result = cv::Mat.new
    cv::draw_matches(mat1,features1,mat2,features2,good_matches,result)
    cv::imshow("result",result)
    cv::wait_key(1000)

  end

  def match_keypoints(ref_path, img_path)
    img1 = cv::imread(img_path,cv::IMREAD_GRAYSCALE)
    img2 = cv::imread(ref_path,cv::IMREAD_GRAYSCALE)

    if (img1.empty() || img2.empty())
      Rails.logger.info("One of the image is missing")
      return false
    end

    keypoints1=Vector.new(cv::KeyPoint)
    keypoints2=Vector.new(cv::KeyPoint)

    detector = cv::FeatureDetector::create("SURF")
    extractor = cv::DescriptorExtractor::create("SURF")
    matcher = cv::DescriptorMatcher::create("BruteForce")

    detector.detect(img1, keypoints1)
    detector.detect(img2, keypoints2)

    # computing descriptors
    descriptors2=cv::Mat.new(3, 4, cv::CV_64FC1)
    descriptors1=cv::Mat.new(3, 4, cv::CV_64FC1)
    extractor.compute(img1, keypoints1, descriptors1)
    extractor.compute(img2, keypoints2, descriptors2)

    # matching descriptors
    matches= Vector.new(cv::DMatch)
    matcher.match(descriptors1, descriptors2, matches)

    # drawing the results
    img_matches=cv::Mat.new(3, 4, cv::CV_64FC1)
    cv::draw_matches(img1, keypoints1, img2, keypoints2, matches, img_matches)
    cv::imshow("matches", img_matches)
    cv::waitKey(0)
  end

  def compare_histogram(img_path)
    ref = cv::Mat.new
    img = cv::Mat.new

    ref_hsv = cv::Mat.new
    ref_hsv_base_half_down = Mat.new
    img_hsv = cv::Mat.new


    img1 = cv::imread(img_path,cv::IMREAD_COLOR)
    img2 = cv::imread(ref_path,cv::IMREAD_COLOR)

    cv::cvt_color(ref,  ref_hsv, cv::COLOR_BGR2HSV)
    cv::cvt_color(img,  img_hsv, cv::COLOR_BGR2HSV)

    ref_hsv_base_half_down = ref_hsv( cv::Range( hsv_base.rows/2, hsv_base.rows - 1 ),
                                      cv::Range( 0, hsv_base.cols - 1 ) )
    h_bins = 50
    s_bins = 60

    histSize = [] << h_bins << s_bins
    h_ranges = %w|0 180|
    s_ranges = %w|0 256|
    ranges = [] << h_ranges << s_ranges

    channels = %w|0 1|


    hist_ref = cv::Mat.new
    hist_ref_half_down = cv::Mat.new
    hist_img = cv::Mat.new
    

  end


end
