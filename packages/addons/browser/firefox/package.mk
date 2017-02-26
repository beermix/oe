PKG_NAME="firefox"
PKG_VERSION="51.0.1"
PKG_URL="http://releases.mozilla.org/pub/firefox/releases/51.0.1/source/firefox-51.0.1.source.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"

https://github.com/archlinuxarm/PKGBUILDs/blob/master/extra/firefox/PKGBUILD

# Google API keys (see http://www.chromium.org/developers/how-tos/api-keys)
# Note: These are for Arch Linux use ONLY. For your own distribution, please
# get your own set of keys. Feel free to contact foutrelis@archlinux.org for
# more information.
# - Arch Linux ARM has obtained permission to use the Arch Linux keys.
_google_api_key=AIzaSyDwr302FpOSkGRpLlUpPThNTDPbXcIn_FM

# Mozilla API keys (see https://location.services.mozilla.com/api)
# Note: These are for Arch Linux use ONLY. For your own distribution, please
# get your own set of keys. Feel free to contact heftig@archlinux.org for
# more information.
_mozilla_api_key=16674381-f021-49de-8622-3021c5942aff


prepare() {
 cd $pkgname-$pkgver

 cp ../mozconfig .mozconfig
 patch -Np1 -i ../firefox-install-dir.patch

 # https://bugzilla.mozilla.org/show_bug.cgi?id=1314968
 patch -Np1 -i ../fix-wifi-scanner.diff

 # Build with the rust targets we actually ship
 patch -Np1 -i ../rust-i686.patch

 echo -n "$_google_api_key" >google-api-key
 echo "ac_add_options --with-google-api-keyfile=\"$PWD/google-api-key\"" >>.mozconfig

 echo -n "$_mozilla_api_key" >mozilla-api-key
 echo "ac_add_options --with-mozilla-api-keyfile=\"$PWD/mozilla-api-key\"" >>.mozconfig

 mkdir "$srcdir/path"
 ln -s /usr/bin/python2 "$srcdir/path/python"

 [[ $CARCH != "aarch64" ]] && echo "ac_add_options --disable-ion" >> .mozconfig \
 && echo "ac_add_options --disable-elf-hack" >> .mozconfig
 LDFLAGS+=" -Wl,--no-keep-memory -Wl,--reduce-memory-overheads"
 patch -p1 -i ../mozilla-1253216.patch
 patch -p1 -i ../mozilla-build-arm.patch
}

build() {
 cd $pkgname-$pkgver

 # _FORTIFY_SOURCE causes configure failures
 CPPFLAGS+=" -O2"

 # Hardening
 LDFLAGS+=" -Wl,-z,now"

 # GCC 6
 CXXFLAGS+=" -fno-delete-null-pointer-checks -fno-schedule-insns2"

 export PATH="$srcdir/path:$PATH"

 # Do PGO
 #xvfb-run -a -s "-extension GLX -screen 0 1280x1024x24" \
 # make -f client.mk build MOZ_PGO=1
 make -f client.mk build
}

package() {
 cd $pkgname-$pkgver
 make -f client.mk DESTDIR="$pkgdir" INSTALL_SDK= install

 install -Dm644 ../vendor.js "$pkgdir/usr/lib/firefox/browser/defaults/preferences/vendor.js"

 for i in 16 22 24 32 48 256; do
 install -Dm644 browser/branding/official/default$i.png \
 "$pkgdir/usr/share/icons/hicolor/${i}x${i}/apps/firefox.png"
 done
 install -Dm644 browser/branding/official/content/icon64.png \
 "$pkgdir/usr/share/icons/hicolor/64x64/apps/firefox.png"
 install -Dm644 browser/branding/official/mozicon128.png \
 "$pkgdir/usr/share/icons/hicolor/128x128/apps/firefox.png"
 install -Dm644 browser/branding/official/content/about-logo.png \
 "$pkgdir/usr/share/icons/hicolor/192x192/apps/firefox.png"
 install -Dm644 browser/branding/official/content/about-logo@2x.png \
 "$pkgdir/usr/share/icons/hicolor/384x384/apps/firefox.png"
 install -Dm644 ../firefox-symbolic.svg \
 "$pkgdir/usr/share/icons/hicolor/symbolic/apps/firefox-symbolic.svg"

 install -Dm644 ../firefox.desktop \
 "$pkgdir/usr/share/applications/firefox.desktop"

 # Use system-provided dictionaries
 rm -rf "$pkgdir"/usr/lib/firefox/{dictionaries,hyphenation}
 ln -s /usr/share/hunspell "$pkgdir/usr/lib/firefox/dictionaries"
 ln -s /usr/share/hyphen "$pkgdir/usr/lib/firefox/hyphenation"

 # Replace duplicate binary with symlink
 # https://bugzilla.mozilla.org/show_bug.cgi?id=658850
 ln -sf firefox "$pkgdir/usr/lib/firefox/firefox-bin"
}

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
