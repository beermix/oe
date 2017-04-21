PKG_NAME="nmap"
PKG_VERSION="7.40"
PKG_SITE="http://nmap.org/"
PKG_URL="http://nmap.org/dist/${PKG_NAME}-${PKG_VERSION}.tgz"
PKG_DEPENDS_TARGET="toolchain netbsd-curses libpcap libdnet pcre"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
  
  export CPPFLAGS="$CPPFLAGS -DNOLUA"
  export LDFLAGS="$LDFLAGS -lpthread"
  export XAKE_FLAGS="GCC_HONOUR_COPTS=s"
}

PKG_CONFIGURE_OPTS_TARGET="ac_cv_dnet_bsd_bpf=no \
                           --without-openssl \
                           --without-zenmap \
                           --without-ndiff \
                           --without-liblua \
                           --with-pcap=$SYSROOT_PREFIX/usr \
                           --with-liblinear=included \
                           --with-libpcre=$SYSROOT_PREFIX/usr \
                           --enable-static"