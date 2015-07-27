require 'ropencv'
require 'aws/s3'

module ROpenCV

  include OpenCV


  def get_image_data(filename)
    s3 = Aws::S3::Client.new
    bucket = s3.buckets[ENV["AWS_BUCKET"]]
    obj = bucket.objects[file_key]
    obj.read
  end

  def get_image()
    m = cv::Mat.new(3,3,cv::CV_64FC1)
  end


  def extract_face()
  end

  def get_mat_gray(img_data){
    cv::Mat gray_image;
    cv::cvtColor( img_data, gray_image, CV_BGR2GRAY );
  }

  def extract_text(img_data)
    Mat gray_image;
    cvtColor( image, gray_image, CV_BGR2GRAY );
  end

  def search_object()
  end

  def generate_color_histogram()
  end


end
