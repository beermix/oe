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
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"
CONCURRENCY_MAKE_LEVEL=1

post_unpack() {
 rm $ROOT/$PKG_BUILD/m4/libtool.m4
 #strip_lto
}

#CFLAGS="$CFLAGS -Wall -Wextra -pedantic -Wno-overlength-strings"
#CFLAGS="$CFLAGS -DXML_UNICODE"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static --with-gnu-ld --with-pic"
			      
PKG_CONFIGURE_OPTS_HOST="--prefix=$ROOT/$TOOLCHAIN $PKG_CONFIGURE_OPTS_TARGET"


PKG_CMAKE_OPTS_TARGET="-DBUILD_tools=OFF -DBUILD_examples=OFF -DBUILD_tests=OFF -DBUILD_shared=OFF"

PKG_CMAKE_SCRIPT_TARGET="expat/CMakeLists.txt"

#post_unpack() {
#  cp -r $PKG_BUILD/expat/* $PKG_BUILD/
#}

#pre_make_target() { 
#  cp -r ../doc .
#}