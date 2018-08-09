PKG_NAME="intel-gpu-tools"
PKG_VERSION="1.23"
PKG_SITE="https://www.x.org/releases/individual/app/?C=M;O=D" # https://cgit.freedesktop.org/xorg/app/intel-gpu-tools/log/
PKG_URL="https://www.x.org/releases/individual/app/igt-gpu-tools-$PKG_VERSION.tar.xz"
#PKG_URL="https://cgit.freedesktop.org/xorg/app/intel-gpu-tools/snapshot/$PKG_VERSION.tar.xz"
PKG_SOURCE_DIR="igt-gpu-tools-$PKG_VERSION"
PKG_DEPENDS_TARGET="toolchain peg:host kmod systemd procps-ng libpciaccess mesa libdrm libpciaccess cairo swig:host libunwind"
PKG_SECTION="tools"
PKG_TOOLCHAIN="autotools"
#PKG_TOOLCHAIN="meson"

PKG_CONFIGURE_OPTS_TARGET="--disable-tests \
			      --disable-shared \
			      --enable-static \
			      --with-gnu-ld \
			      --disable-git-hash \
			      --disable-debug \
			      --disable-amdgpu \
			      --disable-nouveau \
			      --enable-intel"
			      
PKG_MESON_OPTS_TARGET="-Dbuild_overlay=true \
			  -Doverlay_backends=x \
			  -Dbuild_audio=false \
			  -Dbuild_chamelium=false \
			  -Dwith_valgrind=false \
			  -Dbuild_man=false \
			  -Dbuild_docs=false \
			  -Dbuild_tests=false \
			  -Dwith_libdrm=intel"
			  
# -Duse_rpath=false