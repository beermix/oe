PKG_NAME="coreutils"
PKG_VERSION="8.25"
PKG_URL="http://ftpmirror.gnu.org/coreutils/coreutils-$PKG_VERSION.tar.xz"
PKG_BUILD_DEPENDS_TARGET="toolchain acl libunwind attr libcap readline"
#PKG_BUILD_DEPENDS_TARGET="toolchain netbsd-curses grep openssl libcap attr libunwind"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

CFLAGS="-march=corei7-avx -mtune=corei7-avx -fdata-sections -ffunction-sections -O3 -Wa,--noexecstack"
LDFLAGS="-s -Wl,-O1,--as-needed"

PKG_CONFIGURE_OPTS_TARGET="gl_cv_func_working_mktime=yes \
			   gl_cv_func_linkat_follow=yes \
			   gl_cv_func_mknod_works=yes \
			   gl_cv_func_getgroups_works=yes \
			   fu_cv_sys_stat_statfs2_bsize=yes \
			   --prefix=/usr \
			   --without-selinux \
			   --disable-nls \
			   --enable-no-install-program=hostname,su,kill,uptime,env,mkdir"