wget https://github.com/Itseez/opencv/archive/2.4.11.zip
7z x 2.4.11.zip
mkdir -p opencv-2.4.11/release
cd opencv-2.4.11/release
cmake -D CMAKE_BUILD_TYPE=RELEASE -D WITH_FFMPEG=OFF -D CMAKE_INSTALL_PREFIX=/usr/local ..
make
make install
sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'
ldconfig
cd /
rm -rf opencv-2.4.11
