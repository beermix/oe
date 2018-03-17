PKG_NAME="xmlrpc-c"
PKG_VERSION="1.16.44"
PKG_SITE="http://xmlrpc-c.sourceforge.net"
PKG_URL="http://sources.openelec.tv/mirror/xmlrpc-c/xmlrpc-c-1.16.44.tgz"
PKG_DEPENDS_TARGET="toolchain openssl curl zlib libxml2 libsigc++"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--enable-libxml2-backend \
            --disable-nls \
            --enable-static \
            --disable-shared \
            --disable-cplusplus \
            --disable-libwww-client \
            --disable-wininet-client \
            --disable-abyss-server \
            --disable-cgi-server"

pre_build_target() {
  # fix curl includes
  sed -i -e '/curl\/types.h/d' $PKG_BUILD/lib/curl_transport/curlmulti.c
  sed -i -e '/curl\/types.h/d' $PKG_BUILD/lib/curl_transport/curltransaction.c
  sed -i -e '/curl\/types.h/d' $PKG_BUILD/lib/curl_transport/xmlrpc_curl_transport.c

  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
}

post_makeinstall_target() {
  sed -i "s:/usr/include:$LIB_PREFIX/include:g" $SYSROOT_PREFIX/usr/bin/xmlrpc-c-config
  sed -i "s:/usr/lib:$LIB_PREFIX/lib:g" $SYSROOT_PREFIX/usr/bin/xmlrpc-c-config
}
