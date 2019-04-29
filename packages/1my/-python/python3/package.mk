PKG_NAME="python3"
PKG_VERSION="3.4.0"
PKG_URL="https://www.python.org/ftp/python/3.4.0/Python-3.4.0.tar.xz"
PKG_SOURCE_DIR="Python-3.4.0"
PKG_DEPENDS_TARGET="toolchain sqlite expat zlib bzip2 openssl libffi"


PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_file_dev_ptc=no \
                           ac_cv_file_dev_ptmx=yes \
                           ac_cv_func_lchflags_works=no \
                           ac_cv_func_chflags_works=no \
                           ac_cv_func_printf_zd=yes \
                           ac_cv_buggy_getaddrinfo=no \
                           ac_cv_header_bluetooth_bluetooth_h=no \
                           ac_cv_header_bluetooth_h=no \
                           ac_cv_file__dev_ptmx=no \
                           ac_cv_file__dev_ptc=no \
                           ac_cv_have_long_long_format=yes"