PKG_NAME="intel-gpu-tools"
PKG_VERSION="d5de89e"
PKG_SITE="https://www.x.org/releases/individual/app/?C=M;O=D"
PKG_GIT_URL="git://anongit.freedesktop.org/xorg/app/intel-gpu-tools"
#PKG_URL="http://xorg.freedesktop.org/releases/individual/app/intel-gpu-tools-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain systemd procps-ng glib mesa libdrm libpciaccess cairo dri2proto swig:host"
PKG_SECTION="tools"
PKG_SHORTDESC="x11-utils"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="enable_gtk_doc=no --disable-tests --without-libunwind --disable-shared --enable-static --with-gnu-ld"
