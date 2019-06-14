PKG_NAME="freshplayerplugin"
PKG_VERSION="58596f4"
PKG_SITE="https://github.com/i-rinat/freshplayerplugin"
PKG_URL="https://github.com/i-rinat/freshplayerplugin/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain ragel:host alsa xrandr libXrender libXcursor libdrm libevent freetype openssl icu libva cairo pango libva-vdpau-driver"
PKG_TOOLCHAIN="cmake-make"

get_graphicdrivers

PKG_CMAKE_OPTS_TARGET="-DWITH_LIBV4L2=0 \
			  -DWITH_JACK=0 \
			  -DWITH_PEPPERFLASH=1 \
			  -DWITH_PULSEAUDIO=1 \
			  -DCMAKE_BUILD_TYPE=Release"
