PKG_NAME="rhash"
PKG_VERSION="1.3.8"
PKG_SITE="https://github.com/rhash/RHash/releases"
PKG_URL="https://github.com/rhash/RHash/archive/v$PKG_VERSION.tar.gz"

configure_host() {
  cd $PKG_BUILD
  ./configure \
  --prefix=$TOOLCHAIN \
  --enable-lib-static \
  --disable-lib-shared
}

post_makeinstall_host() {
  cd $PKG_BUILD

  make install-pkg-config
  make install-lib-static
  make install-binary
}
