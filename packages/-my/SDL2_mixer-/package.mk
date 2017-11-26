PKG_NAME="SDL2_mixer"
PKG_VERSION="2.0.1"
PKG_SITE="http://www.libsdl.org/"
PKG_URL="http://www.libsdl.org/projects/SDL_mixer/release/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain SDL2 libmad libogg flac"

PKG_SECTION="multimedia"
PKG_SHORTDESC="libsdl_mixer: Simple Directmedia Layer - Mixer"
PKG_LONGDESC="SDL_mixer is a sound mixing library that is used with the SDL library, and almost as portable. It allows a programmer to use multiple samples along with music without having to code a mixing algorithm themselves. It also simplyfies the handling of loading and playing samples and music from all sorts of file formats."



PKG_CONFIGURE_OPTS_TARGET="--enable-music-cmd \
                           --enable-music-wave \
                           --disable-music-mod \
                           --disable-music-midi \
                           --enable-sttaic \
                           --disable-shared \
                           --disable-music-timidity-midi \
                           --disable-music-native-midi \
                           --disable-music-native-midi-gpl \
                           --enable-music-ogg \
                           --enable-music-ogg-shared \
                           --enable-music-flac \
                           --enable-music-flac-shared \
                           --enable-music-mp3 \
                           --enable-music-mp3-shared \
                           --enable-music-mp3-mad-gpl \
                           --enable-smpegtest \
                           --with-gnu-ld \
                           --with-sdl-prefix=$SYSROOT_PREFIX/usr"
