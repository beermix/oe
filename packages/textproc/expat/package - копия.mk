PKG_NAME="expat"
PKG_VERSION="2.2.0"
PKG_URL="$SOURCEFORGE_SRC/$PKG_NAME/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.bz2"
#PKG_VERSION="5ceb385"
#PKG_GIT_URL="https://github.com/libexpat/libexpat"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="textproc"
PKG_SHORTDESC="expat: XML parser library"
PKG_LONGDESC="Expat is an XML parser library written in C. It is a stream-oriented parser in which an application registers handlers for things the parser might find in the XML document (like start tags). An introductory article on using Expat is available on xml.com."

PKG_IS_ADDON="no"
PKG_USE_CMAKE="yes"
PKG_AUTORECONF="no"

CFLAGS="$CFLAGS -Wall -Wextra -pedantic -Wno-overlength-strings"
#CFLAGS="$CFLAGS -DXML_UNICODE"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DBUILD_tools=OFF -DBUILD_examples=OFF -DBUILD_tests=OFF -DBUILD_shared=ON"

pre_make_target() {
  # fix builderror when building in subdirs
  cp -r ../doc .
}