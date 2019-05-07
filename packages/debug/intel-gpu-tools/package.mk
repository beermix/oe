PKG_NAME="intel-gpu-tools"
PKG_VERSION="f052e49a43cc9704ea5f240df15dd9d3dfed68ab"
PKG_SITE="https://www.x.org/releases/individual/app/?C=M;O=D" # https://cgit.freedesktop.org/xorg/app/intel-gpu-tools/
PKG_URL="https://www.x.org/releases/individual/app/intel-gpu-tools-$PKG_VERSION.tar.xz"
PKG_URL="https://cgit.freedesktop.org/xorg/app/intel-gpu-tools/snapshot/$PKG_VERSION.tar.xz"
#PKG_SOURCE_DIR="$PKG_VERSION"
PKG_DEPENDS_TARGET="toolchain clang:host libxml llvm zlib"
PKG_DEPENDS_TARGET="toolchain systemd procps-ng glib mesa libdrm libpciaccess cairo swig:host libunwind libunwind libXv"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-tests \
			      --disable-shared \
			      --enable-static \
			      --disable-git-hash \
			      --disable-debug \
			      --disable-amdgpu \
			      --disable-nouveau \
			      --disable-libunwind \
			      --enable-intel"