PKG_NAME="coreutils"
PKG_VERSION="8.25"
PKG_URL="http://ftpmirror.gnu.org/coreutils/coreutils-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain acl attr libcap pcre readline openssl"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--without-gmp \
			      --without-selinux \
			      --with-openssl \
			      --enable-silent-rules \
			      --enable-threads=posix \
			      --enable-no-install-program=printf,logname,pr,mv,ln,nl,numfmt,pathchk,true,md5sum,mkdir,env,hostname,su,kill,uptime,uname,pwd,readlink,seq,basename,mkfifo,mknod,mktemp,nohup,od,printenv,realpath,touch,mtab"