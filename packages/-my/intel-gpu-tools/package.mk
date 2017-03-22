PKG_NAME="intel-gpu-tools"
PKG_VERSION="intel-gpu-tools-1.18"
PKG_GIT_URL="git://anongit.freedesktop.org/xorg/app/intel-gpu-tools"
PKG_DEPENDS_TARGET="toolchain systemd mesa libdrm libpciaccess cairo libunwind"
PKG_SECTION="tools"
PKG_SHORTDESC="x11-utils"
PKG_AUTORECONF="yes"

pre_configure_taret() {
  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-Os|"`
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --enable-silent-rules \
			      --disable-debug \
			      --with-libunwind \
			      --disable-gtk-doc \
			      --disable-gtk-doc-html \
			      --disable-gtk-doc-pdf"
