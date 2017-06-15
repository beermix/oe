PKG_NAME="fftw"
PKG_VERSION="3.3.6-pl2"
PKG_URL="ftp://ftp.fftw.org/pub/fftw/fftw-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libnl"
PKG_SECTION="service/system"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fopenmp"
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-threads \
			      --enable-openmp \
			      --enable-float \
			      --enable-sse2 \
			      --enable-sse \
			      --enable-avx \
			      --enable-silent-rules"

post_makeinstall_target() {
  rm -rf $INSTALL
}