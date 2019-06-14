PKG_NAME="pcre2"
PKG_VERSION="10.33"
PKG_SHA256="bc7045250ce94d8022c121c1884970ae532f2cdc3295c03975cca8628e9febc6"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="zlib:host"
PKG_DEPENDS_TARGET="toolchain zlib"
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+pic:host +pic"
PKG_TOOLCHAIN="cmake-make"

#PKG_CONFIGURE_OPTS_TARGET="--enable-pcre2-8 --enable-pcre2-16 --disable-pcre2grep-callout"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --enable-utf8 \
			      --enable-pcre2-16 \
			      --enable-jit \
			      --enable-unicode-properties \
			      --with-gnu-ld"

PKG_CONFIGURE_OPTS_HOST="--prefix=$TOOLCHAIN $PKG_CONFIGURE_OPTS_TARGET"

PKG_CMAKE_OPTS_TARGET="-DBUILD_SHARED_LIBS=0 \
			  -DCMAKE_BUILD_TYPE=Release \
			  -DPCRE_SUPPORT_UNICODE_PROPERTIES=1 \
			  -DPCRE_SUPPORT_UTF=1 \
			  -DPCRE_SUPPORT_JIT=1 \
			  -DCMAKE_VERBOSE_MAKEFILE=0"

#post_makeinstall_target() {
#  rm -rf $INSTALL/usr/bin
#  sed -e "s:\(['= ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" -i $SYSROOT_PREFIX/usr/bin/$PKG_NAME-config
#}
