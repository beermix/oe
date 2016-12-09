PKG_NAME="icu"
PKG_VERSION="58_1"
PKG_URL="http://download.icu-project.org/files/icu4c/58.1/icu4c-$PKG_VERSION-src.tgz"
PKG_SOURCE_DIR="icu"
PKG_DEPENDS_TARGET="toolchain"
PKG_DEPENDS_HOST="toolchain Python:host"

PKG_AUTORECONF="no"

PKG_CONFIGURE_SCRIPT="source/configure"

PKG_CONFIGURE_OPTS_TARGET="--disable-debug \
			  --enable-release \
			  --disable-shared \
			  --enable-static \
			  --enable-draft \
			  --enable-renaming \
			  --disable-tracing \
			  --disable-extras \
			  --enable-dyload \
			  --enable-layout \
			  --enable-layoutex \
			  --disable-tools \
			  --disable-tests \
			  --disable-samples \
			  --with-cross-build=$ROOT/$TOOLCHAIN"
		
		
PKG_CONFIGURE_OPTS_HOST="--disable-debug \
			 --enable-release \
			 --disable-shared \
			 --enable-static"