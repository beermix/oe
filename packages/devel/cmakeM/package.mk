PKG_NAME="cmake"
PKG_VERSION="3.7.20161122-g6e51a-Linux-x86_64"
PKG_URL="https://cmake.org/files/dev/cmake-$PKG_VERSION.tar.gz"
PKG_SECTION="toolchain/devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_host() {
  : # nothing todo
}

post_make_host() {
  mkdir -p $ROOT/$TOOLCHAIN/bin
  ln -sfP $ROOT/$PKG_BUILD/bin/* $ROOT/$TOOLCHAIN/bin
  
  mkdir -p $ROOT/$TOOLCHAIN/share
  ln -sfP $ROOT/$PKG_BUILD/share/* $ROOT/$TOOLCHAIN/share
    
  #  find $ROOT/$TOOLCHAIN -maxdepth 3 -exec ln -s $ROOT/$PKG_BUILD/bin {} \;
}

makeinstall_host() {
  : # nothing todo 
}