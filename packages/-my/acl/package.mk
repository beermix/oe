PKG_NAME="acl"
PKG_VERSION="2.2.52"
PKG_URL="http://download.savannah.gnu.org/releases/acl/acl-2.2.52.src.tar.gz"
PKG_DEPENDS_TARGET="toolchain attr"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
  	#libtoolize --force && aclocal -I m4 && autoconf && autoheader
	sed -i \
		-e '/^as_dummy=/s:=":="$PATH$PATH_SEPARATOR:' \
		configure # hack PATH with AC_PATH_PROG
	sed -i \
		-e "/^PKG_DOC_DIR/s:@pkg_name@:$pkgname:" \
		-e '/HAVE_ZIPPED_MANPAGES/s:=.*:=false:' \
		include/builddefs.in \
		|| return 1
}

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr --disable-shared --enable-static --disable-gettext"