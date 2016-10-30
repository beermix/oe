PKG_NAME="nmap"
PKG_VERSION="7.31"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://nmap.org/"
PKG_URL="http://nmap.org/dist/${PKG_NAME}-${PKG_VERSION}.tgz"
PKG_DEPENDS_TARGET="toolchain netbsd-curses libpcap libdnet pcre"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME

  export CPPFLAGS="$CPPFLAGS -Iliblua"
}


PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --with-pcap=linux \
                           --with-liblua=included \
                           --with-liblinear=included \
                           --with-libpcre=$SYSROOT_PREFIX/usr \
                           --without-ncat \
                           --without-ndiff \
                           --without-zenmap"


