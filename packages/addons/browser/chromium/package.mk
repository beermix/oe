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
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="chromium"
PKG_VERSION="62.0.3202.75"
#PKG_SHA256="e8df3150386729ddcb4971636627e54815ad447be5f122201e310f5bb0bcc362"
PKG_REV="107.008"
PKG_ARCH="x86_64"
PKG_LICENSE="Mixed"
PKG_SITE="http://www.chromium.org/Home"
PKG_URL="ftp://root:openelec@192.168.1.4/www/chromium-$PKG_VERSION.tar.xz"
#PKG_URL="https://commondatastorage.googleapis.com/chromium-browser-official/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="toolchain ninja:host Python2:host"
PKG_DEPENDS_TARGET="chromium:host pciutils dbus x11 ffmpeg yasm libXcomposite libXcursor libXtst alsa-lib bzip2 libXScrnSaver libexif libpng harfbuzz atk gtk2 unclutter xdotool libvdpau minizip"
PKG_SECTION="browser"
PKG_SHORTDESC="Chromium Browser: the open-source web browser from Google"
PKG_LONGDESC="Chromium Browser ($PKG_VERSION): the open-source web browser from Google"
PKG_AUTORECONF="no"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="Chromium"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES="executable"

export CCACHE_SLOPPINESS=include_file_mtime

post_patch() {
  cd $(get_build_dir chromium)
  # Use Python 2
  find . -name '*.py' -exec sed -i -r "s|/usr/bin/python$|$TOOLCHAIN/bin/python2|g" {} +

  # set correct widevine
  sed -i -e 's/@WIDEVINE_VERSION@/Pinkie Pie/' ./third_party/widevine/cdm/stub/widevine_cdm_version.h

}

make_host() {
  ./tools/gn/bootstrap/bootstrap.py --no-rebuild --no-clean
}

makeinstall_host() {
  :
}

make_target() {
  strip_lto
  export LDFLAGS="$LDFLAGS -ludev"
  export LD=$CXX

  # Google API keys (see http://www.chromium.org/developers/how-tos/api-keys)
  # Note: These are for OpenELEC use ONLY. For your own distribution, please
  # get your own set of keys.

  _google_api_key=AIzaSyAQ6L9vt9cnN4nM0weaa6Y38K4eyPvtKgI
  _google_default_client_id=740889307901-4bkm4e0udppnp1lradko85qsbnmkfq3b.apps.googleusercontent.com
  _google_default_client_secret=9TJlhL661hvShQub4cWhANXa

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
    'link_pulseaudio=false'
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
    'use_vulcanize=false'
    'use_vaapi=true'
    'exclude_unwind_tables=true'
    "target_sysroot=\"${SYSROOT_PREFIX}\""
    'enable_hangout_services_extension=true'
    'enable_widevine=true'
    'enable_nacl=false'
    'enable_nacl_nonsfi=false'
    'enable_swiftshader=false'
    "google_api_key=\"${_google_api_key}\""
    "google_default_client_id=\"${_google_default_client_id}\""
    "google_default_client_secret=\"${_google_default_client_secret}\""
  )


  # Possible replacements are listed in build/linux/unbundle/replace_gn_files.py
  local _system_libs=(
    harfbuzz-ng
    libjpeg
    libpng
    libxslt
    yasm
  )

  # Remove bundled libraries for which we will use the system copies; this
  # *should* do what the remove_bundled_libraries.py script does, with the
  # added benefit of not having to list all the remaining libraries
  local _lib
  for _lib in ${_system_libs}; do
    find -type f -path "*third_party/$_lib/*" \
      \! -path "*third_party/$_lib/chromium/*" \
      \! -path "*third_party/$_lib/google/*" \
      \! -regex '.*\.\(gn\|gni\|isolate\|py\)' \
      -delete
  done

  ./build/linux/unbundle/replace_gn_files.py --system-libraries "${_system_libs}"
  ./third_party/libaddressinput/chromium/tools/update-strings.py

  ./out/Release/gn gen out/Release --args="${_flags[*]}" --script-executable=$TOOLCHAIN/bin/python2

  ninja -j2 -C out/Release chrome chrome_sandbox widevinecdmadapter
}

makeinstall_target() {
  :
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P  $PKG_BUILD/out/Release/chrome $ADDON_BUILD/$PKG_ADDON_ID/bin/chromium.bin
  cp -P  $PKG_BUILD/out/Release/chrome_sandbox $ADDON_BUILD/$PKG_ADDON_ID/bin/chrome-sandbox
  cp -P  $PKG_BUILD/out/Release/{*.pak,*.dat,*.bin,libwidevinecdmadapter.so} $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -PR $PKG_BUILD/out/Release/locales $ADDON_BUILD/$PKG_ADDON_ID/bin/
  cp -PR $PKG_BUILD/out/Release/gen/content/content_resources.pak $ADDON_BUILD/$PKG_ADDON_ID/bin/
  # config
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/config
  cp -P $PKG_DIR/config/* $ADDON_BUILD/$PKG_ADDON_ID/config

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/lib

  # pango
  cp -PL $(get_build_dir pango)/.install_pkg/usr/lib/libpangocairo-1.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir pango)/.install_pkg/usr/lib/libpango-1.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir pango)/.install_pkg/usr/lib/libpangoft2-1.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # cairo
  cp -PL $(get_build_dir cairo)/.install_pkg/usr/lib/libcairo.so.2 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # gtk2
  cp -PL $(get_build_dir gtk2)/.install_pkg/usr/lib/libgdk-x11-2.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir gtk2)/.install_pkg/usr/lib/libgtk-x11-2.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # harfbuzz
  cp -PL $(get_build_dir harfbuzz)/.install_pkg/usr/lib/libharfbuzz.so* $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir harfbuzz)/.install_pkg/usr/lib/libharfbuzz-icu.so* $ADDON_BUILD/$PKG_ADDON_ID/lib

  # gdk-pixbuf
  cp -PL $(get_build_dir gdk-pixbuf)/.install_pkg/usr/lib/libgdk_pixbuf-2.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  
  # atk
  cp -PL $(get_build_dir atk)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib
  
  # libvdpau
  cp -r -i $(get_build_dir libvdpau)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib
  
  # libXScrnSaver
  cp -r -i $(get_build_dir libXScrnSaver)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib

  # pixbuf loaders
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/gdk-pixbuf-modules
  cp -PL $(get_build_dir gdk-pixbuf)/.install_pkg/usr/lib/gdk-pixbuf-2.0/2.10.0/loaders/* $ADDON_BUILD/$PKG_ADDON_ID/gdk-pixbuf-modules

  # libexif
  cp -PL $(get_build_dir libexif)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib

  # unclutter
  cp -P $(get_build_dir unclutter)/.install_pkg/usr/bin/unclutter $ADDON_BUILD/$PKG_ADDON_ID/bin

  # xdotool
  cp -P $(get_build_dir xdotool)/xdotool $ADDON_BUILD/$PKG_ADDON_ID/bin
}
