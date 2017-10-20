PKG_NAME="intel-gpu-tools"
PKG_VERSION="1.20"
PKG_SITE="https://www.x.org/releases/individual/app/?C=M;O=D"
PKG_URL="https://www.x.org/releases/individual/app/intel-gpu-tools-$PKG_VERSION.tar.gz"
#PKG_GIT_URL="git://anongit.freedesktop.org/xorg/app/intel-gpu-tools"
PKG_DEPENDS_TARGET="toolchain systemd procps-ng glib mesa libdrm libpciaccess cairo dri2proto swig:host"
PKG_SECTION="tools"
PKG_SHORTDESC="x11-utils"
PKG_AUTORECONF="yes"
PKG_USE_MESON="no"

PKG_CONFIGURE_OPTS_TARGET="enable_gtk_doc=no --disable-tests --without-libunwind --disable-shared"

PKG_MESON_OPTS_TARGET=""