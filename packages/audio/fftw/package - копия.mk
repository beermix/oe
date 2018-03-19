PKG_NAME="fftw"
PKG_VERSION="3.3.7"
PKG_SITE="ftp://ftp.fftw.org/pub/fftw/"
PKG_URL="ftp://ftp.fftw.org/pub/fftw/fftw-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="service/system"
PKG_TOOLCHAIN="cmake-make"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fomit-frame-pointer -malign-double -fstrict-aliasing -ffast-math -fopenmp -fPIC"
}

PKG_CMAKE_OPTS_TARGET="-DBUILD_SHARED_LIBS=0 -DBUILD_TESTS=0"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --with-gnu-ld \
			      --enable-threads \
			      --enable-openmp \
			      --enable-silent-rules \
			      --enable-sse2 \
			      --enable-avx"

post_makeinstall_target() {
  rm -rf $INSTALL
}