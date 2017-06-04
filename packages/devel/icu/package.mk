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

post_unpack() {
  cp -r $PKG_BUILD/source/* $PKG_BUILD/
}

#pre_configure_target() {
#  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3|"`
#  export CXXFLAGS="$CXXFLAGS -std=c++11"
#}

#PKG_CONFIGURE_SCRIPT="source/runConfigureICU"
#PKG_CONFIGURE_SCRIPT="source/configure"

PKG_CONFIGURE_OPTS_HOST="--enable-static --disable-shared --enable-release --disable-silent-rules"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --disable-shared \
                           --enable-release \
                           --disable-silent-rules \
                           --with-cross-build=$ROOT/$PKG_BUILD/.$HOST_NAME"

post_makeinstall_target() {
  rm -rf $INSTALL
}
