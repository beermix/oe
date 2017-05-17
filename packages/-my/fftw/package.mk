PKG_NAME="fftw"
PKG_VERSION="3.3.6-pl2"
PKG_URL="ftp://ftp.fftw.org/pub/fftw/fftw-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="service/system"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export CFLAGS="$CFLAGS -O3 -fomit-frame-pointer -malign-double -fstrict-aliasing -ffast-math -fopenmp"
}

PKG_CONFIGURE_OPTS_TARGET="--enable-shared \
			      --enable-threads \
			      --enable-openmp \
			      --disable-fortran \
			      --enable-float \
			      --enable-sse2 \
			      --enable-avx"
