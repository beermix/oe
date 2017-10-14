PKG_NAME="jack2"
PKG_VERSION="ff1ed2c"
PKG_URL="https://github.com/jackaudio/jack2/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain flac bzip2 libsamplerate opus"

PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


configure_target() {
  cd $PKG_BUILD
  export LIBS="-ltermcap"
  export PYTHON_VERSION="2.7"
  export PYTHON_CPPFLAGS="-I$SYSROOT_PREFIX/usr/include/python$PYTHON_VERSION"
  export PYTHON_LDFLAGS="-L$SYSROOT_PREFIX/usr/lib/python$PYTHON_VERSION -lpython$PYTHON_VERSION"
  export PYTHON_SITE_PKG="$SYSROOT_PREFIX/usr/lib/python$PYTHON_VERSION/site-packages"
  ./waf configure ${PKG_CONFIGURE_OPTS}
}


make_target() {
./waf
}

makeinstall_target() {
./waf -p build --force --out=${ROOT}/${PKG_BUILD}
./waf -p install --force --prefix=${ROOT}/${PKG_BUILD}
}

PKG_CONFIGURE_OPTS="-v --prefix=${ROOT}/${PKG_BUILD} \
			--doxygen=no \
			--alsa=yes \
			--firewire=no  \
			--freebob=no \
			--iio=no \
			--winmme=no \
			--samplerate=yes \
			--sndfile=no \
			--color=yes \
			--celt=no \
			--opus=no \
			--readline=no \
			--enable-pkg-config-dbus-service-dir \

			--classic \
			--check-cxx-compiler=g++"
#make_target() {
#  cd $PKG_BUILD
#  ./waf build
# ./waf install prefix=$INSTALL/usr
#}


