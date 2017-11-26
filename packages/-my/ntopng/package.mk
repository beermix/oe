PKG_NAME="ntopng"
PKG_VERSION="2.4-stable"
PKG_URL="http://downloads.sourceforge.net/project/ntop/ntopng/ntopng-2.4-stable.tar.gz"
PKG_DEPENDS_TARGET="toolchain readline"

PKG_SECTION="tools"


pre_configure_target() {
   cd $PKG_BUILD
   export LDFLAGS="-ldl -lpthread -lsqlite3"
   sh autogen.sh
}


PKG_CONFIGURE_OPTS_TARGET="ac_cv_lib_sqlite3_sqlite3_open=yes \
			   --prefix=/usr \
			   --sysconfdir=/storage/.config \
			   --datarootdir=/storage/.config"