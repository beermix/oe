PKG_NAME="perl"
PKG_VERSION="1.1.6"
PKG_GIT_URL="https://github.com/arsv/perl-cross/"
PKG_DEPENDS_TARGET="toolchain pcre openssl gdbm expat"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="-Dld="$CC" \
			      -Dccflags="$CFLAGS" \
			      -Dldflags='$LDFLAGS -lm' \
			      -Dmydomain="" \
			      -Dmyhostname="noname" \
			      -Dmyuname="OE" \
			      -Dosname=linux \
			      -Dperladmin=root"