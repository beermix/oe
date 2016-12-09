PKG_NAME="alsa-plugins"
PKG_VERSION="1.1.1"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.alsa-project.org/"
PKG_URL="ftp://ftp.alsa-project.org/pub/plugins/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain alsa-lib libsamplerate"

PKG_SECTION="audio"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"


# package specific configure options
PKG_CONFIGURE_OPTS_TARGET="--enable-static --enable-shared --with-plugindir=/usr/lib/alsa"



post_makeinstall_target() {
  rm -rf $INSTALL/usr/share
}
