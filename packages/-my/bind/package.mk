PKG_NAME="bind"
PKG_VERSION="9.11.1"
PKG_URL="http://www.mirrorservice.org/sites/ftp.isc.org/isc/bind9/9.11.1/bind-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain sqlite libcap openssl readline rapidjson"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

#pre_configure_taret() {
#  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-Os|"`
#}

PKG_CONFIGURE_OPTS_TARGET="BUILD_CC="$HOST_CC" \
                           --with-openssl=$SYSROOT_PREFIX/usr \
                           --enable-static \
                           --disable-shared \
                           --sysconfdir=/storage/.config \
                           --with-randomdev=/dev/urandom \
                           --with-ecdsa=yes \
                           --with-libxml2=$SYSROOT_PREFIX/usr \
                           --with-readline=$SYSROOT_PREFIX/usr \
                           --with-gssapi=no \
                           --with-gost=no \
                           --with-libjson=no \
                           --enable-seccomp=no"


