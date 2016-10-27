PKG_NAME="autogen"
PKG_VERSION="5.18.12"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://sources.redhat.com/autogen/"
PKG_URL="ftp://ftp.gnu.org/gnu/autogen/rel$PKG_VERSION/autogen-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="autoconf:host guile:host"
PKG_PRIORITY="optional"
PKG_SECTION="toolchain/devel"
PKG_SHORTDESC="automake: A GNU tool for automatically creating Makefiles"
PKG_LONGDESC="This is Automake, a Makefile generator. It was inspired by the 4.4BSD make and include files, but aims to be portable and to conform to the GNU standards for Makefile variables and targets. Automake is a Perl script. The input files are called Makefile.am. The output files are called Makefile.in; they are intended for use with Autoconf. Automake requires certain things to be done in your configure.in."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_HOST="--without-guile --disable-silent-rules"

PKG_CONFIG="$ROOT/$TOOLCHAIN/bin/pkgconfig"