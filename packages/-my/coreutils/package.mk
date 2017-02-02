PKG_NAME="coreutils"
PKG_VERSION="8.25"
PKG_URL="http://ftpmirror.gnu.org/coreutils/coreutils-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain acl attr libcap pcre readline gmp openssl"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--bindir=/bin \
			      --with-gmp \
			      --without-selinux \
			      --with-openssl \
			      --enable-silent-rules \
			      --with-gnu-ld \
			      --enable-no-install-program=env,hostname,su,kill,uptime,uname,pwd,readlink,seq,basename,mkfifo,mknod,mktemp,nohup,od,printenv,realpath,touch,mtab"