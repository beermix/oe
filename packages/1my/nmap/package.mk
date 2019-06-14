PKG_NAME="nmap"
PKG_VERSION="976668b"
PKG_SITE="http://nmap.org/"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_URL="https://github.com/nmap/nmap/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses libpcap libdnet pcre"
PKG_SECTION="tools"

pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
  export CPPFLAGS="$CPPFLAGS -Iliblua"
  #export LDFLAGS="$LDFLAGS -lz -lpthread -lm -ldl"
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --with-pcap=linux \
                           --with-liblua=included \
                           --with-liblinear=included \
                           --with-libpcre=$SYSROOT_PREFIX/usr \
                           --without-ncat \
                           --without-ndiff \
                           --without-zenmap \
                           --with-gnu-ld"