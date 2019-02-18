PKG_NAME="crossguid"
PKG_VERSION="8f399e8bd4"
PKG_URL="https://dl.dropboxusercontent.com/s/78rcj8bheoz8lq2/crossguid-8f399e8bd4.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="tools"
PKG_USE_CMAKE="no"


pre_configure_target() {
# attr fails to build in subdirs
  cd $PKG_BUILD
    rm -rf .$TARGET_NAME
}

make_target() {
  $CXX -c guid.cpp -o guid.o -Wall -std=c++11 -DGUID_LIBUUID
  $CXX -c test.cpp -o test.o -Wall -std=c++11
  $CXX -c testmain.cpp -o testmain.o -Wall
  $CXX test.o guid.o testmain.o -o test -luuid
  chmod +x test
./test
}