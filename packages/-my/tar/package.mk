PKG_NAME="tar"
PKG_VERSION="1.29b"
PKG_URL="https://dl.dropboxusercontent.com/s/v6c3gnd15ufozt2/tar-1.29b.tar.xz"
PKG_DEPENDS_TARGET="toolchain pcre acl"
PKG_PRIORITY="optional"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

CFLAGS="-march=corei7-avx -mtune=corei7-avx -fdata-sections -ffunction-sections -O3 -Wa,--noexecstack -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE"
LDFLAGS="-s -Wl,-O1,--as-needed"

PKG_CONFIGURE_OPTS_TARGET="gl_cv_func_mbrtowc_incomplete_state=yes gl_cv_func_wcrtomb_retval=no --with-gnu-ld"