PKG_NAME="intel-gpu-tools"
PKG_VERSION="1.24"
PKG_SHA256="57357c72feeafc923c9cfd2d1234bd80e120fc7cc6099eac81158ec351a821bf"
PKG_SITE="https://www.x.org/releases/individual/app/?C=M;O=D"
PKG_SITE="https://cgit.freedesktop.org/xorg/app/intel-gpu-tools/log/"
PKG_URL="https://www.x.org/releases/individual/app/igt-gpu-tools-$PKG_VERSION.tar.xz"
#PKG_URL="https://cgit.freedesktop.org/xorg/app/intel-gpu-tools/snapshot/$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain systemd procps-ng glib elfutils mesa libdrm libpciaccess cairo swig:host libunwind libXv"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-tests \
			      --disable-shared \
			      --enable-static \
			      --enable-overlay \
			      --disable-debug \
			      --disable-amdgpu \
			      --disable-nouveau \
			      --enable-intel"

PKG_MESON_OPTS_TARGET="-Dbuild_overlay=enabled \
                       -Doverlay_backends=x,xv \
                       -Dbuild_man=disabled \
                       -Dwith_valgrind=disabled \
                       -Dbuild_audio=disabled \
                       -Dbuild_chamelium=disabled \
                       -Dbuild_docs=disabled \
                       -Dbuild_tests=disabled \
                       -Dwith_libdrm=intel \
                       -Dwith_libunwind=disabled \
                       -Dbuild_runner=disabled"