PKG_NAME="protobuf-c"
PKG_VERSION="v1.2.1"
PKG_SITE="https://developers.google.com/protocol-buffers/"
PKG_GIT_URL="https://github.com/protobuf-c/protobuf-c"
PKG_DEPENDS_HOST="toolchain zlib:host Python:host"
PKG_DEPENDS_TARGET="toolchain zlib"
PKG_SECTION="devel"
PKG_USE_CMAKE="no"

PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-shared --enable-static --disable-protoc"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"
