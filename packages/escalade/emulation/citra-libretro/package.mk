# Made by github.com/escalade
PKG_NAME="citra-libretro"
PKG_VERSION="c56cff5"
PKG_REV="1"
PKG_ARCH="x86_64"
PKG_LICENSE="GPLv2+"
PKG_SITE="https://github.com/libretro/citra"
PKG_DEPENDS_TARGET="toolchain boost curl"
PKG_SECTION="escalade"
PKG_SHORTDESC="A Nintendo 3DS Emulator"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DENABLE_LIBRETRO=1 \
                       -DENABLE_SDL2=0 \
                       -DENABLE_QT=0 \
                       -DCMAKE_BUILD_TYPE=\"Release\" \
                       -DBOOST_ROOT=$(get_build_dir boost) \
                       -DUSE_SYSTEM_CURL=1 \
                       -DTHREADS_PTHREAD_ARG=OFF \
                       -DCMAKE_NO_SYSTEM_FROM_IMPORTED=1 \
                       -DCMAKE_VERBOSE_MAKEFILE=1 \
                       --target citra_libretro"
pre_build_target() {
  git clone --recursive $PKG_SITE $PKG_BUILD/$PKG_NAME-git
  cd $PKG_BUILD/$PKG_NAME-git
  git reset --hard $PKG_VERSION
  cd -
  mv $PKG_BUILD/$PKG_NAME-git/* $PKG_BUILD/
  mv $PKG_BUILD/$PKG_NAME-git/.gitmodules $PKG_BUILD/
  rm -rf $PKG_BUILD/$PKG_NAME-git
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp src/citra_libretro/citra_libretro.so $INSTALL/usr/lib/libretro/
}
