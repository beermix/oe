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

pre_configure_target() {
 export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3|"`
 export CXXLAGS=`echo $CXXLAGS | sed -e "s|-O.|-O3|"`
}

post_unpack() {
  cp -r $PKG_BUILD/source/* $PKG_BUILD/
}

PKG_CONFIGURE_OPTS_HOST="--enable-static --disable-shared --enable-release"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --disable-shared \
                           --enable-release \
                           --with-cross-build=$ROOT/$PKG_BUILD/.$HOST_NAME"

PKG_CONFIGURE_SCRIPT="source/configure"

post_makeinstall_target() {
  rm -rf $INSTALL
}
