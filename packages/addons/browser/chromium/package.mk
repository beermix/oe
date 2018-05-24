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
#  https://chromereleases.googleblog.com/
#  http://svnweb.mageia.org/packages/cauldron/chromium-browser-stable/current
#  http://omahaproxy.appspot.com/
#  https://www.chromestatus.com/
################################################################################ beautifulsoup4:host html5lib:host re2 snappy

PKG_NAME="chromium"
PKG_VERSION="63.0.3239.132"
PKG_SHA256=""
PKG_REV="121"
PKG_ARCH="x86_64"
PKG_LICENSE="Mixed"
PKG_SITE="http://www.chromium.org/Home"
PKG_URL="https://commondatastorage.googleapis.com/chromium-browser-official/chromium-$PKG_VERSION.tar.xz"
#PKG_URL="https://gsdview.appspot.com/chromium-browser-official/chromium-$PKG_VERSION.tar.xz"
#PKG_URL="http://192.168.1.200:8080/%2Fchromium-66.0.3359.117.tar.xz"
PKG_DEPENDS_HOST="toolchain ninja:host Python2:host gperf:host libevent:host"
PKG_DEPENDS_HOST="toolchain ninja:host Python2:host"
PKG_DEPENDS_TARGET="pciutils systemd dbus libXtst libXcomposite libXcursor alsa-lib bzip2 yasm nss libXScrnSaver libexif libpng atk xdotool libdrm libjpeg-turbo freetype libxslt harfbuzz gtk+ chromium:host"
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
  find . -name '*.py' -exec sed -i -r "s|/usr/bin/python$|$TOOLCHAIN/bin/python|g" {} +

  # set correct widevine
  sed -i -e 's/@WIDEVINE_VERSION@/Pinkie Pie/' ./third_party/widevine/cdm/stub/widevine_cdm_version.h
}

make_host() {
  export CCACHE_SLOPPINESS=time_macros
  ./tools/gn/bootstrap/bootstrap.py --no-rebuild --no-clean
}

make_target() {
#  unset CPPFLAGS
#  unset CFLAGS
#  unset CXXFLAGS
#  unset LDFLAGS

#  export CXXFLAGS="$CXXFLAGS -Wno-attributes -Wno-comment -Wno-unused-variable -Wno-noexcept-type -Wno-register -Wno-strict-overflow -Wno-deprecated-declarations -fdiagnostics-color=always"

  export LDFLAGS="$LDFLAGS -ludev"
  export LD=$CXX

  # Allow building against system libraries in official builds
  sed -i 's/OFFICIAL_BUILD/GOOGLE_CHROME_BUILD/' ./tools/generate_shim_headers/generate_shim_headers.py

  # Work around broken screen sharing in Google Meet
  # https://crbug.com/829916#c16
  sed -i 's/"Chromium/"Chrome/' ./chrome/common/chrome_content_client_constants.cc

  export CCACHE_CPP2=yes
  export CCACHE_SLOPPINESS=time_macros

  # Google API keys (see http://www.chromium.org/developers/how-tos/api-keys)
  # Note: These are for OpenELEC use ONLY. For your own distribution, please
  # get your own set of keys.
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
    'link_pulseaudio=true'
    'linux_use_bundled_binutils=false'
    'use_allocator="none"'
    'use_cups=false'
    'use_custom_libcxx=false'
    'use_gconf=false'
    'use_gnome_keyring=false'
    'use_gold=false'
    'use_gtk3=false'
    'use_kerberos=false'
    'use_pulseaudio=false'
    'use_sysroot=true'
    'use_vaapi=true'
    'use_v8_context_snapshot=false'
    'enable_vulkan=false'
    "target_sysroot=\"${SYSROOT_PREFIX}\""
    'exclude_unwind_tables=true'
    'enable_hangout_services_extension=false'
    'enable_widevine=false'
    'enable_nacl=false'
    'enable_nacl_nonsfi=false'
    'enable_swiftshader=false'
    'enable_vulkan=false'
    "google_api_key=\"${_google_api_key}\""
    "google_default_client_id=\"${_google_default_client_id}\""
    "google_default_client_secret=\"${_google_default_client_secret}\""
  )

  ./third_party/libaddressinput/chromium/tools/update-strings.py

  ./out/Release/gn gen out/Release --args="${_flags[*]}" --script-executable=$TOOLCHAIN/bin/python

  ninja -j${CONCURRENCY_MAKE_LEVEL} $NINJA_OPTS -C out/Release chrome chrome_sandbox
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P  $PKG_BUILD/out/Release/chrome $ADDON_BUILD/$PKG_ADDON_ID/bin/chromium.bin
  cp -P  $PKG_BUILD/out/Release/chrome_sandbox $ADDON_BUILD/$PKG_ADDON_ID/bin/chrome-sandbox
  cp -P  $PKG_BUILD/out/Release/{*.pak,*.dat,*.bin} $ADDON_BUILD/$PKG_ADDON_ID/bin
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

  # harfbuzz
  cp -ri $(get_build_dir harfbuzz)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib

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

  # unclutter
  # cp -P $(get_build_dir unclutter)/.install_pkg/usr/bin/unclutter $ADDON_BUILD/$PKG_ADDON_ID/bin

  # xdotool
  cp -P $(get_build_dir xdotool)/xdotool $ADDON_BUILD/$PKG_ADDON_ID/bin
}
