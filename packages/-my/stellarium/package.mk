PKG_NAME="stellarium"
PKG_VERSION="a6c68b4"
PKG_GIT_URL="https://github.com/Stellarium/stellarium"
PKG_DEPENDS_TARGET="toolchain zlib openssl speex taglib xorg pulseaudio boost pango openjpeg mtdev libxslt tinyxml2 SDL SDL_mixer"
PKG_AUTORECONF="no"


PKG_CMAKE_OPTS_TARGET="-DENABLE_MEDIA=1 \
		       -DENABLE_NLS=1 \
		       -DENABLE_SCRIPTING=1 \
		       -DENABLE_SCRIPT_CONSOLE=1 \
		       -DGENERATE_PACKAGE_TARGET=1 \
		       -DSTELLARIUM_GUI_MODE=None \
		       -DSTELLARIUM_RELEASE_BUILD=1 \
		       -DSTELLARIUM_USE_CPP11=1 \
		       -DUSE_PLUGIN_ANGLEMEASURE=1 \
		       -DUSE_PLUGIN_ARCHAEOLINES=1 
		       -DUSE_PLUGIN_SUPERNOVAE=1"