require 'zlib'
require 'ropencv'
include OpenCV


FRONTALFACE_CONFIG="/usr/local/share/xml/haarcascade/haarcascade_frontalface.xml"
Rails.FaceCascade = cv::CascadeClassifier.new
Rails.FaceCascade.load(FRONTALFACE_CONFIG)
