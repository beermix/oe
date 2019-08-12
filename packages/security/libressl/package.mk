PKG_NAME="libressl"
PKG_VERSION="3.0.0"
PKG_SHA256=""
PKG_SITE="http://mirror.ox.ac.uk/pub/OpenBSD/LibreSSL/?C=M;O=D"
PKG_URL="http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SHORTDESC="libressl: a FREE version of the SSL/TLS protocol forked from OpenSSL"
PKG_TOOLCHAIN="autotools"
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+pic:host +pic"

PKG_CONFIGURE_OPTS_HOST="--disable-shared"