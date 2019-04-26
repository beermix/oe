PKG_NAME="nmap"
PKG_VERSION="7.40"
PKG_SITE="http://nmap.org/"
PKG_URL="http://nmap.org/dist/${PKG_NAME}-${PKG_VERSION}.tgz"
PKG_DEPENDS_TARGET="toolchain ncurses libpcap libdnet pcre lua"
PKG_SECTION="tools"


pre_configure_target() {
  cd $PKG_BUILD
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


