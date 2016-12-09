PKG_NAME="intel-gpu-tools"
PKG_VERSION="1.16"
PKG_URL="http://xorg.freedesktop.org/releases/individual/app/intel-gpu-tools-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain systemd mesa libdrm libpciaccess cairo"

PKG_SECTION="tools"
PKG_SHORTDESC="x11-utils"
PKG_AUTORECONF="no"

pre_configure_target() {
libtoolize --automake --copy --force
}

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			   --disable-shared \
			   --enable-static \
			   --with-gnu-ld \
			   --enable-silent-rules \
			   --disable-debug \
			   --without-libunwind \
			   --disable-gtk-doc \
			   --disable-gtk-doc-html \
			   --disable-gtk-doc-pdf"