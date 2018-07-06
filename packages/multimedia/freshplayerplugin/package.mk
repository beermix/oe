PKG_NAME="freshplayerplugin"
PKG_VERSION="4343e4e"
PKG_SITE="https://github.com/i-rinat/freshplayerplugin"
PKG_URL="https://github.com/i-rinat/freshplayerplugin/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain ragel:host libva-vdpau-driver alsa xrandr libXrender libXcursor libdrm libevent freetype openssl icu libva libvdpau cairo pango"
PKG_SECTION="multimedia"
PKG_TOOLCHAIN="cmake-make"
PKG_BUILD_FLAGS="-hardening"

PKG_CMAKE_OPTS_TARGET="-DWITH_LIBV4L2=0 \
			  -DWITH_JACK=0 \
			  -DWITH_PEPPERFLASH=1 \
			  -DWITH_PULSEAUDIO=1 \
			  -DCMAKE_BUILD_TYPE=Release"
