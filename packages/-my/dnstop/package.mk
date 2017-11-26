PKG_NAME="dnstop"
PKG_VERSION="20140915"
PKG_URL="http://dns.measurement-factory.com/tools/dnstop/src/dnstop-20140915.tar.gz"
PKG_DEPENDS_TARGET="toolchain systemd"
PKG_SECTION="debug/tools"


PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes --disable-option-checking"

pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
  export LDFLAGS="$LDFLAGS -lresolv"
}