PKG_NAME="systemtap"
PKG_VERSION="3.2"
PKG_URL="https://sourceware.org/systemtap/ftp/releases/systemtap-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="nss:host Python2:host setuptools:host elfutils:host"
PKG_SECTION="devel"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_HOST="--enable-pie \
			    --disable-docs \
			    --disable-htmldoc"