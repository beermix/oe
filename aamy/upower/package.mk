PKG_NAME="upower"
PKG_VERSION="98d98fc"
PKG_GIT_URL="git://anongit.freedesktop.org/upower"
PKG_DEPENDS_TARGET="toolchain libimobiledevice"


pre_configure_target() {
    ( 
      unset LIBTOOL
      sh autogen.sh
    )
}

#PKG_CONFIGURE_OPTS_TARGET="--disable-static --disable-gtk-doc"


