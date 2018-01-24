PKG_NAME="intel-gpu-tools"
PKG_VERSION="1.21"
PKG_SITE="https://www.x.org/releases/individual/app/?C=M;O=D"
PKG_URL="https://www.x.org/releases/individual/app/intel-gpu-tools-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain systemd procps-ng glib mesa libdrm libpciaccess cairo dri2proto swig:host"
PKG_SECTION="tools"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="enable_gtk_doc=no --disable-tests --with-libunwind=no --disable-shared"
