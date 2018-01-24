PKG_NAME="intel-gpu-tools"
PKG_VERSION="1.21"
PKG_SITE="https://www.x.org/releases/individual/app/?C=M;O=D"
PKG_URL="https://www.x.org/releases/individual/app/intel-gpu-tools-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain systemd procps-ng glib mesa libdrm libpciaccess cairo dri2proto swig:host libunwind"
PKG_SECTION="tools"
PKG_TOOLCHAIN="autotools"

pre_configure_target() {
  export LC_ALL=en_US.UTF-8
}

PKG_CONFIGURE_OPTS_TARGET="enable_gtk_doc=no --disable-tests --with-libunwind --disable-shared"
