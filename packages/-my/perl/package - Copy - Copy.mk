PKG_NAME="perl"
PKG_VERSION="5.24.0"
PKG_URL="http://www.cpan.org/src/5.0/perl-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain libressl db less:host"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

configure_target() {
  ./Configure -des -Duselargefiles \
                -Duse64bitint \
                -A ccflags="$CFLAGS -fPIC -DPIC" \
                -Dcc="$CC" \
                -Dldflags="$LDFLAGS -fPIC" \
                -Dlibs="-lm -lcrypt -pthread" \
                -Doptimize="-Os -ffunction-sections -fdata-sections -finline-limit=8 -ffast-math" \
                -Dprefix="/usr" \
                -DEBUGGING=none \
                -Uusevendorprefix \
                -Dusethreads \
                -Duseithreads \
                -Duseperlio \
                -Uman1dir \
                -Uman3dir \
                -Usiteman1dir \
                -Usiteman3dir
}

#                -Doptimize="-Os -ffunction-sections -fdata-sections -finline-limit=8 -ffast-math" \