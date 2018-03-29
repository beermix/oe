PKG_NAME="intel-gpu-tools"
PKG_VERSION="1.22"
PKG_SITE="https://www.x.org/releases/individual/app/?C=M;O=D"
PKG_URL="https://www.x.org/releases/individual/app/intel-gpu-tools-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain systemd procps-ng glib mesa libdrm libpciaccess cairo swig:host libunwind"
PKG_SECTION="tools"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-tests \
			      --disable-shared \
			      --enable-static \
			      --with-gnu-ld \
			      --disable-git-hash \
			      --disable-debug \
			      --disable-vc4 \
			      --disable-amdgpu \
			      --disable-nouveau \
			      --enable-intel"