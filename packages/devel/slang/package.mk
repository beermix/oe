PKG_NAME="slang"
PKG_VERSION="e51a17c"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="http://www.jedsoft.org/slang/"
PKG_GIT_URL="git://git.jedsoft.org/git/slang.git"
PKG_DEPENDS_TARGET="toolchain pcre libpng"
PKG_DEPENDS_TARGET="pcre:host libpng:host"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


pre_configure_target() {
  mkdir -p $ROOT/$PKG_BUILD/.$TARGET_NAME
  cp -a $ROOT/$PKG_BUILD/* $ROOT/$PKG_BUILD/.$TARGET_NAME/

  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-Os|g"`
}

configure_target() {
  cd $ROOT/$PKG_BUILD/.$TARGET_NAME
  
  ./configure --host=$TARGET_NAME --build=$HOST_NAME --prefix=/usr --bindir=/usr/bin --sbindir=/usr/sbin --sysconfdir=/etc \
  --libexecdir=/usr/lib --localstatedir=/var --without-iconv --without-onig --with-pcre --with-png --without-z --without-x
}

make_target() {
  make -C src static -j1
}

makeinstall_target() {
  make DESTDIR="$SYSROOT_PREFIX" -C src install-static
  make DESTDIR="$SYSROOT_PREFIX" install-pkgconfig
}

######################################

pre_configure_host() {
  mkdir -p $ROOT/$PKG_BUILD/.$HOST_NAME
  cp -a $ROOT/$PKG_BUILD/* $ROOT/$PKG_BUILD/.$HOST_NAME/
}

configure_host() {
  cd $ROOT/$PKG_BUILD/.$HOST_NAME
  ./configure --prefix=/ --without-iconv --without-onig --without-pcre --without-png --without-z --without-x
}

makeinstall_host() {
  make -j1 DESTDIR=$ROOT/$TOOLCHAIN -C src install
}
