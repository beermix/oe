PKG_NAME="intel-gpu-tools"
PKG_VERSION="1f67ee0d09d6513f487f2be74aae9700e755258a"
PKG_SITE="https://www.x.org/releases/individual/app/?C=M;O=D"
PKG_SITE="https://cgit.freedesktop.org/xorg/app/intel-gpu-tools/log/"
PKG_URL="https://www.x.org/releases/individual/app/intel-gpu-tools-$PKG_VERSION.tar.xz"
PKG_URL="https://cgit.freedesktop.org/xorg/app/intel-gpu-tools/snapshot/$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain systemd procps-ng glib mesa libdrm libpciaccess cairo swig:host libunwind libXv elfutils peg:host"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-tests \
			      --disable-shared \
			      --enable-static \
			      --disable-git-hash \
			      --disable-debug \
			      --disable-amdgpu \
			      --disable-nouveau \
			      --enable-intel"