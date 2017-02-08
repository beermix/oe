PKG_NAME="coreutils"
PKG_VERSION="8.25"
PKG_URL="http://ftpmirror.gnu.org/coreutils/coreutils-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain acl attr libcap pcre readline openssl"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


PKG_CONFIGURE_OPTS_TARGET="--without-gmp \
			      --without-selinux \
			      --with-openssl \
			      --enable-silent-rules \
			      --enable-install-program=ls,dd,df,du,cp,cat"


post_makeinstall_target() {
  mkdir -p $INSTALL/usr/bin/
  cp src/ls $INSTALL/usr/bin/
  cp src/dd $INSTALL/usr/bin/
  cp src/df $INSTALL/usr/bin/
  cp src/du $INSTALL/usr/bin/
  cp src/cat $INSTALL/usr/bin/
}