PKG_NAME="patch"
PKG_VERSION="2.7.5"
PKG_SITE="http://savannah.gnu.org/projects/patch/"
PKG_URL="ftp://ftp.gnu.org/gnu/patch/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain attr"
PKG_SECTION="devel"
PKG_SHORTDESC="GNU patch"
PKG_LONGDESC="Patch takes a patch file containing a difference listing produced by the diff program and applies those differences to one or more original files, producing patched versions"
PKG_TOOLCHAIN="autotools"

pre_configure_target() {
  export LIBS="$LIBS -ldl"
}

PKG_CONFIGURE_OPTS_TARGET="ac_cv_sys_long_file_names=yes \
			      ac_cv_path_ED=ed \
			      --enable-xattr \
			      --enable-attr \
			      --enable-static \
			      --prefix=/usr"

PKG_CONFIGURE_OPTS_HOST="ac_cv_sys_long_file_names=yes \
			    ac_cv_path_ED=ed \
			    --enable-xattr \
			    --enable-attr \
			    --enable-static \
			    --prefix=/usr \
			    --disable-nls"