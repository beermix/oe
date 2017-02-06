PKG_NAME="wget"
PKG_VERSION="1.19"
PKG_SITE="http://www.wget-editor.org/"
PKG_URL="http://ftpmirror.gnu.org/wget/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain openssl libidn"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

pre_configure_taret() {
  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-Os|"`
}

PKG_CONFIGURE_OPTS_TARGET="--with-ssl=openssl \
                           --without-libgnutls \
                           --enable-largefile \
                           --enable-opie \
                           --enable-digest \
                           --enable-ntlm \
                           --disable-ipv6 \
                           --disable-rpath \
                           --with-metalink"