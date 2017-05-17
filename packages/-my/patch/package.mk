PKG_NAME="patch"
PKG_VERSION="x2"
PKG_URL="https://dl.dropboxusercontent.com/s/rx8fpga49gji565/patch-x2.tar.xz"
PKG_DEPENDS_TARGET="toolchain attr"
PKG_SECTION="devel"
PKG_AUTORECONF="no"

#unpack() {
#  git clone --recursive -v --depth 1 https://github.com/mirror/patch $PKG_BUILD
#}

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  export LIBS="$LIBS -ldl"
  NOCONFIGURE=1 ./bootstrap
}

PKG_CONFIGURE_OPTS_TARGET="ac_cv_sys_long_file_names=yes ac_cv_path_ED=ed --enable-attr"

PKG_CONFIGURE_OPTS_HOST="ac_cv_sys_long_file_names=yes \
			    --enable-xattr \
			    --enable-attr \
			    --enable-static"