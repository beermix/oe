PKG_NAME="coreutils"
PKG_VERSION="8.27"
PKG_URL="http://ftpmirror.gnu.org/coreutils/coreutils-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain attr libcap pcre readline openssl"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="PERL=missing \
			      MAKEINFO=missing \
			      --disable-shared \
			      --without-selinux \
			      --with-openssl \
			      --disable-rpath \
			      --enable-threads=posix"