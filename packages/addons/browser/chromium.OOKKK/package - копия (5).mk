################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
###  beautifulsoup4:host html5lib:host re2 snappy
#  
#  https://chromereleases.googleblog.com/
#  http://svnweb.mageia.org/packages/cauldron/chromium-browser-stable/current
#  http://omahaproxy.appspot.com/
#  https://www.chromestatus.com/
#  https://bazaar.launchpad.net/~chromium-team/chromium-browser/xenial-stable/files/head:/debian?sort=date
################################################################################

PKG_NAME="chromium"
PKG_VERSION="67.0.3396.87"
PKG_SHA256="5d27a72f0cb8247343034f63fdd9747ff388c05b9fceb541668dd04fb372db1d"
PKG_REV="180"
PKG_ARCH="x86_64"
PKG_LICENSE="Mixed"
PKG_URL="https://commondatastorage.googleapis.com/chromium-browser-official/chromium-$PKG_VERSION.tar.xz"
PKG_URL="https://gsdview.appspot.com/chromium-browser-official/chromium-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="toolchain ninja:host Python2:host"
PKG_DEPENDS_TARGET="chromium:host pciutils dbus libXcomposite libXcursor libXtst alsa-lib bzip2 yasm nss libXScrnSaver libexif libpng atk libdrm freetype libxslt harfbuzz gtk+ libva-vdpau-driver unclutter xdotool re2 snappy opus libvpx"
PKG_SECTION="browser"
PKG_SHORTDESC="Chromium Browser: the open-source web browser from Google"
PKG_LONGDESC="Chromium Browser ($PKG_VERSION): the open-source web browser from Google"
PKG_TOOLCHAIN="manual"
PKG_BUILD_FLAGS="-lto -hardening"
GOLD_SUPPORT="yes"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="Chromium"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES="executable"

post_patch() {
  cd $(get_build_dir chromium)

  # Use Python 2
  find . -name '*.py' -exec sed -i -r "s|/usr/bin/python$|$TOOLCHAIN/bin/python2|g" {} +

  # set correct widevine
  sed -i -e 's/@WIDEVINE_VERSION@/Pinkie Pie/' ./third_party/widevine/cdm/stub/widevine_cdm_version.h

  # find ./third_party/icu -type f \! -regex '.*\.\(gn\|gni\|isolate\)' -delete

  # ./build/download_nacl_toolchains.py --packages \
  # nacl_x86_glibc,nacl_x86_newlib,pnacl_newlib,pnacl_translator sync --extract
}

make_host() {
  ./tools/gn/bootstrap/bootstrap.py --no-rebuild --no-clean --verbose
}

make_target() {
  export CCACHE_SLOPPINESS=time_macros
  #export CCACHE_SLOPPINESS=file_macro,time_macros,include_file_mtime,include_file_ctime
  export CCACHE_CPP2=yes

  sed -i 's/OFFICIAL_BUILD/GOOGLE_CHROME_BUILD/' ./tools/generate_shim_headers/generate_shim_headers.py

  #sed -i -e '/"-Wno-ignored-pragma-optimize"/d' ./build/config/compiler/BUILD.gn

  #sed -i '1s|python$|&2|' ./third_party/dom_distiller_js/protoc_plugins/*.py

  # Workaround build error caused by debugedit
  # https://bugzilla.redhat.com/show_bug.cgi?id=304121
#   sed -i "/relpath/s|/'$|'|" ./tools/metrics/ukm/gen_builders.py
#   sed -i 's|^\(#include "[^"]*\)//\([^"]*"\)|\1/\2|' \
 #    ./third_party/webrtc/modules/audio_processing/utility/ooura_fft.cc \
 #    ./third_party/webrtc/modules/audio_processing/utility/ooura_fft_sse2.cc

  local _google_api_key=AIzaSyAQ6L9vt9cnN4nM0weaa6Y38K4eyPvtKgI
  local _google_default_client_id=740889307901-4bkm4e0udppnp1lradko85qsbnmkfq3b.apps.googleusercontent.com
  local _google_default_client_secret=9TJlhL661hvShQub4cWhANXa

  local _flags=(
    "host_toolchain=\"//build/toolchain/linux:x64_host\""
    'is_clang=false'
    'clang_use_chrome_plugins=false'
    'symbol_level=0'
    'is_debug=false'
    'fatal_linker_warnings=false'
    'treat_warnings_as_errors=false'
    'fieldtrial_testing_like_official_build=true'
    'remove_webcore_debug_symbols=true'
    'ffmpeg_branding="Chrome"'
    'proprietary_codecs=true'
    'is_component_build=false'
    'link_pulseaudio=true'
    'linux_use_bundled_binutils=false'
    'use_allocator="none"'
    'use_cups=false'
    'use_custom_libcxx=false'
    'use_gnome_keyring=false'
    'use_gold=false'
    'use_gtk3=false'
    'use_dbus=true'
    'use_kerberos=false'
    'use_pulseaudio=false'
    'linux_link_libudev=true'
    'use_dbus=true'
    'use_cups=false'
    'use_system_zlib=true'
    'use_system_libjpeg=false'
    'use_system_libpng=false'
    'use_system_libdrm=true'
    'use_system_harfbuzz=false'
    'use_system_freetype=false'
    'use_sysroot=true'
    'use_vaapi=true'
    'use_v8_context_snapshot=false'
    'enable_vulkan=false'
    "target_sysroot=\"${SYSROOT_PREFIX}\""
    'enable_hangout_services_extension=true'
    'enable_widevine=true'
    'enable_nacl=false'
    'enable_nacl_nonsfi=false'
    'enable_swiftshader=false'
    'enable_vulkan=false'
    "google_api_key=\"${_google_api_key}\""
    "google_default_client_id=\"${_google_default_client_id}\""
    "google_default_client_secret=\"${_google_default_client_secret}\""
  )

  ./third_party/libaddressinput/chromium/tools/update-strings.py

  ./out/Release/gn gen out/Release --args="${_flags[*]}" --script-executable=$TOOLCHAIN/bin/python2

  ninja -j${CONCURRENCY_MAKE_LEVEL} $NINJA_OPTS -C out/Release chrome chrome_sandbox
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P  $PKG_BUILD/out/Release/chrome $ADDON_BUILD/$PKG_ADDON_ID/bin/chromium.bin
  cp -P  $PKG_BUILD/out/Release/chrome_sandbox $ADDON_BUILD/$PKG_ADDON_ID/bin/chrome-sandbox
  cp -ri  $PKG_BUILD/out/Release/{*.pak,*.dat,*.bin,libwidevinecdmadapter.so} $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -PR $PKG_BUILD/out/Release/locales $ADDON_BUILD/$PKG_ADDON_ID/bin/
  cp -PR $PKG_BUILD/out/Release/gen/content/content_resources.pak $ADDON_BUILD/$PKG_ADDON_ID/bin/

  # config
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/config
  cp -P $PKG_DIR/config/* $ADDON_BUILD/$PKG_ADDON_ID/config

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/lib

  # pango
  cp -ri $(get_build_dir pango)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib

  # cairo
  cp -ri $(get_build_dir cairo)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib

  # atk
  cp -ri $(get_build_dir atk)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib

  # gtk+
  cp -ri $(get_build_dir gtk+)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib

  # gtk3
  # cp -ri $(get_build_dir gtk3)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib
  # cp -ri $(get_build_dir at-spi2-atk)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib
  # cp -ri $(get_build_dir at-spi2-core)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib

  # harfbuzz
  cp -ri $(get_build_dir harfbuzz)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib
  
  # icu
  cp -ri $(get_build_dir icu)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib

  # gdk-pixbuf
  cp -ri $(get_build_dir gdk-pixbuf)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib

  # pixbuf loaders
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/gdk-pixbuf-modules
  cp -PL $(get_build_dir gdk-pixbuf)/.install_pkg/usr/lib/gdk-pixbuf-2.0/2.10.0/loaders/* $ADDON_BUILD/$PKG_ADDON_ID/gdk-pixbuf-modules

  # libexif
  cp -ri $(get_build_dir libexif)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib

  # libXScrnSaver
  cp -ri $(get_build_dir libXScrnSaver)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib

  # libXtst
  cp -ri $(get_build_dir libXtst)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib

  # libXcursor
  cp -ri $(get_build_dir libXcursor)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib

  # libva-vdpau-driver
  cp -PL $(get_build_dir libva-vdpau-driver)/.install_pkg/usr/lib/dri/*.so $ADDON_BUILD/$PKG_ADDON_ID/lib

  # unclutter
  cp -P $(get_build_dir unclutter)/.install_pkg/usr/bin/unclutter $ADDON_BUILD/$PKG_ADDON_ID/bin

  # xdotool
  cp -P $(get_build_dir xdotool)/xdotool $ADDON_BUILD/$PKG_ADDON_ID/bin
}
