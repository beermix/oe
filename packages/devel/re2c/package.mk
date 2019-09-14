PKG_NAME="re2c"
PKG_VERSION="1.2.1"
PKG_SHA256="1a4cd706b5b966aeffd78e3cf8b24239470ded30551e813610f9cd1a4e01b817"
PKG_SITE="https://github.com/skvadrik/re2c/releases"
PKG_URL="https://github.com/skvadrik/re2c/releases/download/$PKG_VERSION/re2c-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="bison:host autotools:host"
#PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_HOST="--disable-docs"

PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"