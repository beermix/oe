PKG_NAME="firefox"
PKG_VERSION="51.0.1"
PKG_URL="http://releases.mozilla.org/pub/firefox/releases/51.0.1/source/firefox-51.0.1.source.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="CROSS_COMPILE=1 \
  		OS_ARCH=Linux \
  		OS_TARGET=Linux \
  		OS_TEST="X86_64" \
  		OS_CXXFLAGS="$CXXFLAGS" \
  		HOST_CC="$HOST_CC" \
  		HOST_CPPFLAGS="$HOST_CPPFLAGS" \
  		HOST_CFLAGS="$HOST_CFLAGS" \
  		HOST_LDFLAGS="$HOST_LDLAGS" \
  		HOST_CXX="$HOST_CXX" \
  		HOST_CXXFLAGS="$HOST_CXXFLAGS" \
  		HOST_RANLIB="ranlib" \
  		HOST_AR="ar" \
  		ac_cv_sqlite_secure_delete=yes \
  		ac_cv_sqlite_threadsafe=yes \
  		ac_cv_sqlite_enable_fts3=yes \
  		ac_cv_sqlite_enable_unlock_notify=yes \
  		ac_cv_sqlite_dbstat_vtab=yes \
  		--prefix=/usr \
  		--target=$TARGET_NAME \
  		--with-toolchain-prefix=$TARGET_NAME \
  		--enable-application=browser \
  		--enable-official-branding \
  		--with-system-zlib \
  		--with-system-bz2 \
  		--with-system-png \
  		--with-system-cairo \
  		--with-system-pixman \
  		--with-system-jpeg \
  		--with-system-nss \
  		--with-system-nspr \
  		--with-system-libvpx \
  		--with-system-libevent=$SYSROOT_PREFIX/usr \
  		--disable-tree-freetype \
  		--enable-system-ffi \
  		--enable-system-sqlite \
  		--enable-chrome-format=jar \
  		--enable-necko-protocols=all \
  		--enable-alsa \
  		--disable-profiling \
  		--disable-jprof \
  		--disable-systrace \
  		--disable-pulseaudio \
  		--disable-gio \
  		--disable-gold \
  		--disable-gconf \
  		--disable-accessibility \
  		--disable-gamepad \
  		--disable-tests \
  		--disable-gnomeui \
  		--disable-optimize \
  		--disable-necko-wifi \
  		--disable-jemalloc \
  		--disable-crashreporter \
  		--disable-printing \
  		--disable-pie"
