PKG_NAME="firefox"
PKG_VERSION="51.0.1"
PKG_URL="http://releases.mozilla.org/pub/firefox/releases/51.0.1/source/firefox-51.0.1.source.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"



make_target() {

#https://github.com/archlinuxarm/PKGBUILDs/blob/master/extra/firefox/PKGBUILD

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


 echo -n "$_google_api_key" >google-api-key
 echo "ac_add_options --with-google-api-keyfile=\"$PWD/google-api-key\"" >>.mozconfig

 echo -n "$_mozilla_api_key" >mozilla-api-key
 echo "ac_add_options --with-mozilla-api-keyfile=\"$PWD/mozilla-api-key\"" >>.mozconfig


echo "ac_add_options --disable-ion" >> .mozconfig \
echo "ac_add_options --disable-elf-hack" >> .mozconfig
LDFLAGS+=" -Wl,--no-keep-memory -Wl,--reduce-memory-overheads"

CXXFLAGS+=" -fno-delete-null-pointer-checks -fno-schedule-insns2"


 # Do PGO
 #xvfb-run -a -s "-extension GLX -screen 0 1280x1024x24" \
 # make -f client.mk build MOZ_PGO=1
 make -f client.mk build
}
