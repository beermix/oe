PKG_NAME="fftw"
PKG_VERSION="3.3.8"
PKG_SITE="ftp://ftp.fftw.org/pub/fftw/"
PKG_URL="ftp://ftp.fftw.org/pub/fftw/fftw-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
#PKG_TOOLCHAIN="cmake-make"
PKG_BUILD_FLAGS="+pic"

#pre_configure_target() {
#  export CFLAGS="$CFLAGS -malign-double -fstrict-aliasing -ffast-math -fopenmp -fPIC"
#}

PKG_CMAKE_OPTS_TARGET="-DBUILD_SHARED_LIBS=0 \
			  -DBUILD_TESTS=0 \
			  -DENABLE_AVX=0 \
			  -DENABLE_AVX2=0 \
			  -DENABLE_FLOAT=1 \
			  -DENABLE_OPENMP=0 \
			  -DENABLE_SSE=1 \
			  -DENABLE_SSE2=2 \
			  -DENABLE_THREADS=1"

post_makeinstall_target() {
  rm -rf $INSTALL
}
