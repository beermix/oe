PKG_NAME="privoxy"
PKG_VERSION="3.0.24-stable"
PKG_SITE="https://www.privoxy.org"
PKG_URL="https://sourceforge.net/projects/ijbswa/files/Sources/3.0.24%20%28stable%29/privoxy-$PKG_VERSION-src.tar.gz"
PKG_DEPENDS_TARGET="toolchain"




configure_target() {
  cd $PKG_BUILD
  CFLAGS="$CFLAGS -fPIC -DPIC"
  strip_lto
  autoreconf -if
  ./configure --prefix=/usr --sysconfdir=/storage/.config/privoxy/ --localstatedir=/storage/.config/privoxy/ --enable-compression  --disable-ipv6-support --enable-large-file-support --with-debug
  cd -
}

make_target() {
  cd $PKG_BUILD
  make
}

post_makeinstall_target() {
  rm -rf $INSTALL/storage
#  rm  $INSTALL/usr/sbin/x86_64-openelec-linux-gnu-strip
}