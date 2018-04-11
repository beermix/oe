PKG_NAME="wine"
PKG_VERSION="3.5"
#PKG_URL="https://dl.winehq.org/wine/source/2.x/wine-$PKG_VERSION.tar.xz"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain wine:host glib gmp x11 mesa xorg-server pcre libXcursor freetype fontconfig libjpeg-turbo libpng tiff libdrm glu expat harfbuzz libxcb libXrender libX11 libXext cairo unclutter xdotool libexif libXcomposite libXtst libpcap"
PKG_DEPENDS_HOST="freetype:host libXcursor:host"
PKG_SECTION="tools"
PKG_TOOLCHAIN="configure"

PKG_CONFIGURE_OPTS_TARGET="--with-wine-tools=$PKG_BUILD/.$HOST_NAME \
			      --disable-tests \
			      --disable-win64 \
			      --without-capi \
			      --without-coreaudio \
			      --without-gettext \
			      --without-gettextpo \
			      --without-gphoto \
			      --without-gsm \
			      --without-hal \
			      --without-opencl \
			      --without-oss \
			      --with-alsa \
			      --with-dbus\
			      --with-fontconfig \
			      --with-freetype \
			      --with-jpeg \
			      --with-glu \
			      --with-pcap \
			      --with-png \
			      --with-xml \
			      --with-xslt \
			      --with-curses \
			      --with-tiff \
			      --with-udev \
			      --with-x \
			      --with-xcomposite \
			      --with-xcursor \
			      --with-xinerama \
			      --with-zlib"

PKG_CONFIGURE_OPTS_HOST="--disable-tests \
			    --disable-win16 \
			    --enable-win64"

make_host() {
    cd $PKG_BUILD/.$HOST_NAME
    make tools \
	  tools/sfnt2fon \
	  tools/widl \
	  tools/winebuild \
	  tools/winegcc \
	  tools/wmc \
	  tools/wrc
}