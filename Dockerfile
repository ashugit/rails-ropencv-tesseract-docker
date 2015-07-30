FROM ruby:2.2

RUN apt-get update -qq && apt-get install -y build-essential

RUN apt-get install -y libpq-dev
RUN apt-get install -y libxml2-dev libxslt1-dev
RUN apt-get install -y imagemagick libmagickcore-dev libmagickwand-dev
RUN apt-get install -y libtesseract-dev libleptonica-dev
RUN apt-get install -y  cmake git pkg-config libavcodec-dev libavformat-dev libswscale-dev p7zip-full
RUN apt-get install -y libjpeg-dev libpng-dev libtiff-dev libjasper-dev zlib1g-dev libopenexr-dev libxine2-dev libeigen3-dev libtbb-dev

add	/docker-scripts/opencv.sh	/docker-scripts/opencv.sh
add	/docker-scripts/haarcascade.sh	/docker-scripts/haarcascade.sh
add	/docker-scripts/tesseract.sh	/docker-scripts/tesseract.sh

# run	/bin/sh /docker-scripts/opencv.sh
run	/bin/sh /docker-scripts/haarcascade.sh
run	/bin/sh /docker-scripts/tesseract.sh
WORKDIR /rails
