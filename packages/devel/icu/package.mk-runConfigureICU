PKG_NAME="icu"
PKG_VERSION="61.1"
PKG_ARCH="any"
PKG_LICENSE="Custom"
PKG_SITE="http://download.icu-project.org/files/icu4c/?C=M;O=D"
PKG_URL="http://download.icu-project.org/files/${PKG_NAME}4c/${PKG_VERSION}/${PKG_NAME}4c-${PKG_VERSION//./_}-src.tgz"
PKG_SOURCE_DIR="icu"
PKG_DEPENDS_TARGET="toolchain libiconv icu:host"
PKG_DEPENDS_TARGET="toolchain icu:host"
PKG_SECTION="textproc"
PKG_SHORTDESC="International Components for Unicode library"
PKG_LONGDESC="International Components for Unicode library"
PKG_BUILD_FLAGS="+pic"

post_unpack() {
#  sed -i 's/xlocale/locale/' $PKG_BUILD/source/i18n/digitlst.cpp
  mkdir -p $PKG_BUILD/.$HOST_NAME
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -a $PKG_BUILD/source/* $PKG_BUILD/.$TARGET_NAME/
  cp -a $PKG_BUILD/source/* $PKG_BUILD/.$HOST_NAME/
}

pre_configure_target() {
  LIBS="-latomic"
}

makeinstall_host() {
 : # nothing todo
}

configure_target() {
 cd $PKG_BUILD/.$TARGET_NAME
 ./runConfigureICU Linux \
 		     CC="clang" \
 		     CXX="clang++" \
 		     --prefix=/usr \
 		     --disable-shared \
 		     --enable-static \
 		     --disable-silent-rules \
 		     --with-data-packaging=archive \
 		     --with-cross-build="$PKG_BUILD/.$HOST_NAME"
}

post_makeinstall_target() {
  rm -rf $INSTALL
}