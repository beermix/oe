PKG_NAME="intel-gpu-tools"
PKG_VERSION="1.18"
PKG_URL="http://xorg.freedesktop.org/releases/individual/app/intel-gpu-tools-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain systemd procps-ng mesa libdrm libpciaccess cairo dri2proto swig:host"
PKG_SECTION="tools"
PKG_SHORTDESC="x11-utils"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="enable_gtk_doc=no --disable-tests --without-libunwind"
