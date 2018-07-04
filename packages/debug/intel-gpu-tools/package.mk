PKG_NAME="intel-gpu-tools"
PKG_VERSION="aeb3f4143572b81a907921ad9442858aafe1931e"
PKG_SITE="https://www.x.org/releases/individual/app/?C=M;O=D"
PKG_URL="https://www.x.org/releases/individual/app/intel-gpu-tools-$PKG_VERSION.tar.xz"
PKG_URL="https://cgit.freedesktop.org/xorg/app/intel-gpu-tools/snapshot/$PKG_VERSION.tar.xz"
PKG_SOURCE_DIR="$PKG_VERSION"
PKG_DEPENDS_TARGET="toolchain clang:host libxml llvm zlib"
PKG_DEPENDS_TARGET="toolchain systemd procps-ng glib mesa libdrm libpciaccess cairo swig:host libunwind libXv"
PKG_SECTION="tools"
#PKG_TOOLCHAIN="autotools"

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