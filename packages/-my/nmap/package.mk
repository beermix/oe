PKG_NAME="nmap"
PKG_VERSION="7.60"
PKG_SITE="http://nmap.org/"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain netbsd-curses libpcap libdnet pcre"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
  export CPPFLAGS="$CPPFLAGS -Iliblua"
  export LDFLAGS="$LDFLAGS -lz -lpthread -lm -ldl"
  #export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3|"`
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --with-pcap=linux \
                           --with-liblua=included \
                           --with-liblinear=included \
                           --with-libpcre=$SYSROOT_PREFIX/usr \
                           --without-ncat \
                           --without-ndiff \
                           --without-zenmap"