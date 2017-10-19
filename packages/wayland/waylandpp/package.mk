PKG_NAME="waylandpp"
PKG_VERSION="0ac2c88"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/NilsBrause/waylandpp"
PKG_GIT_URL="https://github.com/pkerling/waylandpp"
PKG_DEPENDS_TARGET="toolchain scons:host"
PKG_PRIORITY="optional"
PKG_SECTION="wayland"
PKG_SHORTDESC="Wayland C++ bindings"
PKG_LONGDESC="Wayland C++ bindings"


PKG_AUTORECONF="no"

pre_make_host() {
  mkdir -p $PKG_BUILD/.$HOST_NAME
    cp -a $PKG_BUILD/* $PKG_BUILD/.$HOST_NAME/
    cd $PKG_BUILD/.$HOST_NAME/
}

make_host() {
  $CXX $CXXFLAGS -std=c++11 -Wall -Werror -Iscanner -o scanner/wayland-scanner++ scanner/scanner.cpp scanner/pugixml.cpp
}

makeinstall_host() {
  mkdir -p $TOOLCHAIN/bin
    cp -a scanner/wayland-scanner++ $TOOLCHAIN/bin
}

pre_make_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
    cp -a $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME/
    cd $PKG_BUILD/.$TARGET_NAME/
}

make_target() {
  wayland-scanner++ protocols/wayland.xml \
                    include/wayland-client-protocol.hpp \
                    src/wayland-client-protocol.cpp

  $CXX $CXXFLAGS -std=c++11 -Wall -Werror -fPIC -Iinclude -shared -lwayland-client -o src/libwayland-client++.so \
                                                                                      src/wayland-client.cpp \
                                                                                      src/wayland-client-protocol.cpp \
                                                                                      src/wayland-util.cpp

  $CXX $CXXFLAGS -std=c++11 -Wall -Werror -fPIC -Iinclude -shared -lwayland-egl -o src/libwayland-egl++.so \
                                                                                   src/wayland-egl.cpp

  $CXX $CXXFLAGS -std=c++11 -Wall -Werror -fPIC -Iinclude -shared -lwayland-cursor -o src/libwayland-cursor++.so \
                                                                                      src/wayland-cursor.cpp
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib
    cp -a src/*.so $INSTALL/usr/lib/

  mkdir -p $SYSROOT_PREFIX/usr/include
    cp -a include/*.hpp $SYSROOT_PREFIX/usr/include/

  mkdir -p $SYSROOT_PREFIX/usr/lib
    cp -a src/*.so $SYSROOT_PREFIX/usr/lib/

  mkdir -p $SYSROOT_PREFIX/usr/share/waylandpp
    cp -a protocols/wayland.xml $SYSROOT_PREFIX/usr/share/waylandpp/
}
