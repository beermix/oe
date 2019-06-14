PKG_NAME="libmcrypt"
PKG_VERSION="2.5.8"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OpenSource"
PKG_SITE="http://sourceforge.net/projects/mcrypt/"
PKG_URL="http://sourceforge.net/projects/mcrypt/files/Libmcrypt/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="security"
PKG_SHORTDESC="crypt library"
PKG_LONGDESC="mcrypt, and the accompanying libmcrypt, are intended to be replacements for the old Unix crypt, except that they are under the GPL and support an ever-wider range of algorithms and modes."

PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_realloc_0_nonnull=yes \
                           ac_cv_func_malloc_0_nonnull=yes \
                           --disable-static \
                           --disable-padlock-support \
                           --disable-shared \
                           --with-pic"

pre_configure_target() {
  # doesn't like to be build in target folder
  cd $PKG_BUILD
  rm -fr .$TARGET_NAME
}

makeinstall_target() {
  # use this version only for addon (don't install it to a system)
  INSTALL_DEV=$PKG_BUILD/.install_dev
  make -j1 install DESTDIR=$INSTALL_DEV $PKG_MAKEINSTALL_OPTS_TARGET

  for i in $(find $INSTALL_DEV/usr/lib/ -name "*.la" 2>/dev/null); do
    sed "s|\(['= ]\)/usr|\\1$INSTALL_DEV/usr|g" $i
  done
}

post_makeinstall_target() {
  rm -rf $INSTALL
}
