PKG_NAME="pseudo"
PKG_VERSION="b6b68db"
PKG_GIT_URL="https://git.yoctoproject.org/git/pseudo"
PKG_DEPENDS_HOST="ccache:host"
PKG_SECTION="toolchain/devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

configure_host() {
  cd $ROOT/$PKG_BUILD
  ./configure --prefix=$ROOT/$TOOLCHAIN \
   	       --cflags="-O2 -pipe" \
   	       --with-rpath=$ROOT/$TOOLCHAIN/usr/lib \
   	       --bits=64 \
   	       --libdir=$ROOT/$TOOLCHAIN/usr/lib \
   	       --with-static-sqlite=/root/build.OE-Generic.x86_64-8.0-devel/toolchain/include/sqlite3.h
}