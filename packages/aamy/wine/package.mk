PKG_NAME="wine"
PKG_VERSION="3.9"
#PKG_URL="https://dl.winehq.org/wine/source/3.0/wine-3.0.tar.xz" wine:host
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain glib x11 mesa xorg-server pcre libXcursor freetype fontconfig libjpeg-turbo libpng tiff libdrm glu expat harfbuzz libxcb libXrender libX11 libXext cairo libexif libXcomposite libXtst libpcap icu xinput imagemagick gstreamer gst-plugins-base"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--with-wine-tools=$PKG_BUILD/.$HOST_NAME \
			      --disable-tests \
			      --disable-win16 \
			      --without-capi \
			      --without-coreaudio \
			      --without-gettext \
			      --without-gettextpo \
			      --without-gphoto \
			      --without-gsm \
			      --without-hal \
			      --without-opencl \
			      --without-oss \
			      --with-dbus \
			      --with-fontconfig \
			      --with-freetype \
			      --with-gstreamer \
			      --with-jpeg \
			      --with-opengl \
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
			      --with-xshape --with-xshm \
			      --with-xinput --with-xinput2 \
			      --with-xinerama \
			      --with-xrandr \
			      --with-xrender \
			      --with-xxf86vm \
			      --with-zlib"

PKG_CONFIGURE_OPTS_HOST="--disable-tests \
			    --disable-win16 \
			    --enable-win64 \
			    --without-alsa \
			    --without-capi \
			    --without-cms \
			    --without-coreaudio \
			    --without-cups \
			    --without-curses \
			    --without-dbus \
			    --without-fontconfig \
			    --without-gphoto \
			    --without-glu \
			    --without-gnutls \
			    --without-gsm \
			    --without-gstreamer \
			    --without-hal \
			    --without-jpeg \
			    --without-krb5 \
			    --without-ldap \
			    --without-mpg123 \
			    --without-netapi \
			    --without-openal \
			    --without-opencl \
			    --without-opengl \
			    --without-osmesa \
			    --without-oss \
			    --without-pcap \
			    --without-pulse \
			    --without-png \
			    --without-sane \
			    --without-tiff \
			    --without-v4l \
			    --without-x \
			    --without-xcomposite \
			    --without-xcursor \
			    --without-xinerama \
			    --without-xinput \
			    --without-xinput2 \
			    --without-xml \
			    --without-xrandr \
			    --without-xrender \
			    --without-xshape \
			    --without-xshm \
			    --without-xslt \
			    --without-xxf86vm \
			    --without-zlib \
			    --without-vulkan \
			    --without-sdl \
			    --without-udev \
			    --with-gettext"

#make_host() {
 # cd $PKG_BUILD/.$HOST_NAME
#  make -C tools $PKG_BUILD/.$HOST_NAME/tools/sfnt2fon $PKG_BUILD/.$HOST_NAME/tools/widl $PKG_BUILD/.$HOST_NAME/tools/winebuild #$PKG_BUILD/.$HOST_NAME/tools/winegcc $PKG_BUILD/.$HOST_NAME/tools/wmc tools/wrc
#}

makeinstall_host() {
  : # nop
}