PKG_NAME="stellarium"
PKG_VERSION="0.15.0"
PKG_URL="https://master.dl.sourceforge.net/project/stellarium/Stellarium-sources/$PKG_VERSION/stellarium-$PKG_VERSION.tar.gz"
#PKG_DEPENDS_TARGET="toolchain zlib openssl speex taglib xorg pulseaudio pango openjpeg mtdev libxslt tinyxml2 SDL SDL_mixer ImageMagick"
PKG_PRIORITY="optional"
PKG_AUTORECONF="no"

configure_target() {
  cmake -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_BUILD_TYPE=Release \
        -DENABLE_MEDIA=1 \
        -DENABLE_NLS=1 \
        -DENABLE_SCRIPTING=1 \
        -DENABLE_SCRIPT_CONSOLE=1 \
        -DGENERATE_PACKAGE_TARGET=1 \
        -DSTELLARIUM_GUI_MODE=None \
        -DSTELLARIUM_RELEASE_BUILD=1 \
        -DSTELLARIUM_USE_CPP11=1 \
        -DUSE_PLUGIN_ANGLEMEASURE=1 \
        -DUSE_PLUGIN_ARCHAEOLINES=1 \
        -DUSE_PLUGIN_SUPERNOVAE=1 \
        ..
}