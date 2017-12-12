PKG_NAME="protobuf-c"
PKG_VERSION="v1.3.0"
PKG_GIT_URL="https://github.com/protobuf-c/protobuf-c"
PKG_DEPENDS_TARGET="toolchain ncurses libpciaccess libxml2 udevil"
PKG_SECTION="debug/tools"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--enable-shared --disable-protoc"

	