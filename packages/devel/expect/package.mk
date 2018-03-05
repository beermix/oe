PKG_NAME="expect"
PKG_VERSION="5.45.4"
PKG_URL="https://downloads.sourceforge.net/project/expect/Expect/5.45.4/expect5.45.4.tar.gz"
PKG_SOURCE_DIR="$PKG_NAME$PKG_VERSION"
PKG_DEPENDS_TARGET="make:host"
PKG_SECTION="devel"
PKG_TOOLCHAIN="configure"

post_unpack() {
  cd $PKG_BUILD
  cp -v configure{,.orig}
  sed 's:/usr/local/bin:/bin:' configure.orig > configure
}

PKG_CONFIGURE_OPTS_HOST="--prefix=$TOOLCHAIN --with-tcl=$TOOLCHAIN/lib --with-tclinclude=$TOOLCHAIN/include"