################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2016 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="chromium"
PKG_VERSION="53.0.2785.143"
PKG_REV="1"
PKG_ARCH="x86_64"
PKG_LICENSE="Mixed"
PKG_SITE="http://www.chromium.org/Home"
PKG_URL="https://commondatastorage.googleapis.com/chromium-browser-official/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain pciutils dbus libXcomposite libXcursor libXtst alsa-lib bzip2 yasm libXScrnSaver libexif  libpng harfbuzz atk gtk+ ninja:host nss"
PKG_PRIORITY="optional"
PKG_SECTION="xmedia/browser"
PKG_SHORTDESC="Chromium Browser: the open-source web browser from Google"
PKG_LONGDESC="Chromium Browser: the open-source web browser from Google"
PKG_AUTORECONF="no"
PKG_IS_ADDON="no"

pre_make_target() {
  export MAKEFLAGS="-j4"
  strip_lto
  touch chrome/test/data/webui/i18n_process_css_test.html
  sed -i -e 's/@WIDEVINE_VERSION@/Pinkie Pie/' third_party/widevine/cdm/stub/widevine_cdm_version.h

  # Native Client (NaCl)
  python build/download_nacl_toolchains.py \
      --packages nacl_x86_newlib,pnacl_newlib,pnacl_translator \
      sync --extract
}

make_target() {
  export -n CFLAGS CXXFLAGS
  export LDFLAGS="$LDFLAGS -ludev"

  # Google API keys (see http://www.chromium.org/developers/how-tos/api-keys)
  # Note: These are for AlexELEC use ONLY. For your own distribution, please
  # get your own set of keys.

  _google_api_key=AIzaSyADWILIfivEgonwYkoO3w6xwyWfuNlPzeM
  _google_default_client_id=1058644186824-i9jgfv72cd3p032tnluchqpklgnlejsr.apps.googleusercontent.com
  _google_default_client_secret=3NN7qvE3D0TpB1HbNMYMBu_Z


  local _chromium_conf=(
    -Dgoogle_api_key=$_google_api_key
    -Dgoogle_default_client_id=$_google_default_client_id
    -Dgoogle_default_client_secret=$_google_default_client_secret
    -Dtarget_arch=x64
    -Dfastbuild=2
    -Dwerror=
    -Dclang=0
    -Dpython_ver=2.7
    -Dlinux_link_gsettings=0
    -Dlinux_strip_binary=1
    -Dlinux_use_bundled_binutils=0
    -Dlinux_use_bundled_gold=0
    -Dlinux_use_gold_flags=0
    -Dicu_use_data_file_flag=1
    -Dlogging_like_official_build=1
    -Dtracing_like_official_build=1
    -Dfieldtrial_testing_like_official_build=1
    -Dremove_webcore_debug_symbols=1
    -Drelease_extra_cflags="$CFLAGS"
    -Dlibspeechd_h_prefix=speech-dispatcher/
    -Dffmpeg_branding=Chrome
    -Dproprietary_codecs=1
    -Duse_system_bzip2=1
    -Duse_system_flac=0
    -Duse_system_ffmpeg=0
    -Duse_system_harfbuzz=1
    -Duse_system_icu=1
    -Duse_system_libevent=0
    -Duse_system_libjpeg=1
    -Duse_system_libpng=1
    -Duse_system_libvpx=0
    -Duse_system_libxml=0
    -Duse_system_snappy=0
    -Duse_system_xdg_utils=0
    -Duse_system_yasm=1
    -Duse_system_zlib=0
    -Duse_mojo=0
    -Duse_gconf=0
    -Duse_gnome_keyring=0
    -Duse_pulseaudio=0
    -Duse_kerberos=0
    -Duse_cups=0
    -Denable_hangout_services_extension=1
    -Ddisable_fatal_linker_warnings=1
    -Dsysroot=$SYSROOT_PREFIX
    -Ddisable_glibc=1
    -Denable_widevine=1
    -Denable_nacl=1
    -Denable_pnacl=1)

  ./build/linux/unbundle/replace_gyp_files.py "${_chromium_conf[@]}"
  ./build/gyp_chromium --depth=. "${_chromium_conf[@]}"

  ninja -j4 -C out/Release chrome chrome_sandbox
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/config/chromium
    cp -P out/Release/chrome $INSTALL/usr/config/chromium/chromium.bin
    cp -P out/Release/chrome_sandbox $INSTALL/usr/config/chromium/chrome-sandbox
    cp -P out/Release/{*.pak,*.dat,*.bin,libwidevinecdmadapter.so} $INSTALL/usr/config/chromium
    cp -P out/Release/nacl_helper{,_bootstrap} $INSTALL/usr/config/chromium
    cp -P out/Release/nacl_irt_*.nexe $INSTALL/usr/config/chromium
    cp -P out/Release/gen/content/content_resources.pak $INSTALL/usr/config/chromium
    cp -a out/Release/locales $INSTALL/usr/config/chromium

  $STRIP $INSTALL/usr/config/chromium/chromium.bin
  $STRIP $INSTALL/usr/config/chromium/chrome-sandbox
}

