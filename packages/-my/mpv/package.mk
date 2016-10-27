PKG_NAME="mpv"
PKG_VERSION="0.17.0"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://qt-project.org"
PKG_URL="https://github.com/mpv-player/mpv/archive/v0.17.0.tar.gz"
PKG_DEPENDS="bcm2835-driver bzip2 Python zlib:host zlib libpng tiff dbus glib fontconfigeglibc liberation-fonts-ttf font-util font-xfree86-type1 font-misc-misc gstreamer gst-plugins-base gst-plugins-good gst-omx gst-plugins-bad alsa"
PKG_BUILD_DEPENDS_TARGET="bcm2835-driver bzip2 Python zlib:host zlib libpng tiff dbus glib fontconfig mysql openssl linux-headers eglibc gstreamer gst-plugins-base gst-plugins-good gst-omx gst-plugins-bad alsa"

PKG_PRIORITY="optional"
PKG_SECTION="lib"
PKG_SHORTDESC="MPlayer; video player"
PKG_LONGDESC="MPlayer; video player"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC -DPIC"
  strip_lto
}

PKG_CONFIGURE_OPTS="\
	--prefix=/usr \
	--enable-runtime-cpudetection \
	--enable-cross-compile
"




#pre_configure_target() {
#	pushd $ROOT/$BUILD/${PKG_NAME}-${PKG_VERSION}
#	sed -i -e "/read tmp/d" configure
#	popd
#}

configure_target() {
	CPPFLAGS_SAVE=${CPPFLAGS}
	CFLAGS_SAVE=${CFLAGS}
	LDFLAGS_SAVE=${LDFLAGS}
	YASMFLAGS_SAVE=${YASMFLAGS}

	unset CPPFLAGS
	unset CFLAGS
	unset LDFLAGS
	unset YASMFLAGS

	pushd ${ROOT}/${BUILD}/${PKG_NAME}-${PKG_VERSION}
	./configure ${PKG_CONFIGURE_OPTS}
	popd

	CPPFLAGS=${CPPFLAGS_SAVE}
	CFLAGS=${CFLAGS_SAVE}
	LDFLAGS=${LDFLAGS_SAVE}
	YASMFLAGS=${YASMFLAGS_SAVE}
}

make_target() {
	pushd $ROOT/$BUILD/${PKG_NAME}-${PKG_VERSION}
	make
	popd
}

makeinstall_target() {
	pushd ${ROOT}/${PKG_BUILD}
	mkdir .install_pkg || true
	DESTDIR=.install_pkg/ make install
	popd
}


