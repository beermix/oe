PKG_NAME="libpam"
PKG_VERSION="1.3.1"
PKG_SHA256="eff47a4ecd833fbf18de9686632a70ee8d0794b79aecb217ebd0ce11db4cd0db"
PKG_URL="https://github.com/linux-pam/linux-pam/releases/download/v$PKG_VERSION/Linux-PAM-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--enable-pamlocking \
			      --disable-shared \
			      --enable-static \
			      --disable-audit \
			      --disable-cracklib \
			      --disable-db \
			      --disable-prelude \
			      --disable-lckpwdf \
			      --disable-nis \
			      --disable-regenerate-docu \
			      --disable-rpath \
			      --disable-selinux \
			      --with-gnu-ld \
			      --without-mailspool \
			      --without-xauth"