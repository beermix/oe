PKG_NAME="icu"
PKG_VERSION="59.1"
PKG_ARCH="any"
PKG_LICENSE="Custom"
PKG_SITE="http://www.icu-project.org"
PKG_URL="http://download.icu-project.org/files/${PKG_NAME}4c/${PKG_VERSION}/${PKG_NAME}4c-${PKG_VERSION//./_}-src.tgz"
PKG_SOURCE_DIR="icu"
PKG_DEPENDS_TARGET="toolchain icu:host"
PKG_SECTION="textproc"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

#pre_configure_host() {
# sh $ROOT/$PKG_BUILD/source/runConfigureICU Linux/gcc
#}

post_unpack() {
  cp -r $PKG_BUILD/source/* $PKG_BUILD/
}

PKG_CONFIGURE_OPTS_HOST="--enable-static --disable-shared"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --disable-shared \
                           --with-cross-build=$ROOT/$PKG_BUILD/.$HOST_NAME"

PKG_CONFIGURE_SCRIPT="source/configure"

post_makeinstall_target() {
  rm -rf $INSTALL
}
