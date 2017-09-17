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
PKG_VERSION="61.0.3163.91"
PKG_REV="110"
PKG_ARCH="x86_64"
PKG_LICENSE="Mixed"
PKG_SITE="http://www.chromium.org/Home"
PKG_URL="ftp://root:openelec@192.168.1.4/www/chromium-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain pciutils dbus libXcomposite libXcursor libXtst alsa-lib bzip2 yasm nss libXScrnSaver libexif ninja:host libpng harfbuzz atk gtk+ xdotool libvdpau unclutter libwebp re2 x11 ffmpeg"
PKG_SECTION="browser"
PKG_SHORTDESC="Chromium Browser: the open-source web browser from Google"
PKG_LONGDESC="Chromium Browser ($PKG_VERSION): the open-source web browser from Google"
PKG_AUTORECONF="no"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="Chromium"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES="executable"

GOLD_SUPPORT="yes"

pre_make_target() {
  export CCACHE_SLOPPINESS=include_file_mtime
  strip_lto
  touch chrome/test/data/webui/i18n_process_css_test.html
  sed -i -e 's/@WIDEVINE_VERSION@/Pinkie Pie/' third_party/widevine/cdm/stub/widevine_cdm_version.h
  
  mkdir -p third_party/node/linux/node-linux-x64/bin
  ln -sfv /usr/bin/node third_party/node/linux/node-linux-x64/bin/node
}

make_target() {
  export CCACHE_SLOPPINESS=include_file_mtime
#  mkdir -p $ROOT/$PKG_BUILD/out
#  mount -t tmpfs -o size=20G,nr_inodes=40k,mode=1777 tmpfs $ROOT/$PKG_BUILD/out

  export -n CFLAGS CXXFLAGS
  export LDFLAGS="$LDFLAGS -ludev"
#  export LD=$CXX
  
  # Use Python 2
  find . -name '*.py' -exec sed -i -r "s|/usr/bin/python$|$ROOT/$TOOLCHAIN/bin/python|g" {} +

  # Google API keys (see http://www.chromium.org/developers/how-tos/api-keys)
  # Note: These are for OpenELEC use ONLY. For your own distribution, please
  # get your own set of keys.

  _google_api_key=AIzaSyAQ6L9vt9cnN4nM0weaa6Y38K4eyPvtKgI
  _google_default_client_id=740889307901-4bkm4e0udppnp1lradko85qsbnmkfq3b.apps.googleusercontent.com
  _google_default_client_secret=9TJlhL661hvShQub4cWhANXa
  
  sed -e 's|i386-linux-gnu/||g' \
      -e 's|x86_64-linux-gnu/||g' \
      -e 's|/usr/lib/va/drivers|/usr/lib/dri|g' \
      -e 's|/usr/lib64/va/drivers|/usr/lib/dri|g' \
      -i ./content/common/sandbox_linux/bpf_gpu_policy_linux.cc

  export TMPDIR="/root/-f2fs/temp"
  mkdir -p "$TMPDIR"

  local _flags=(
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
    'use_gconf=false'
    'use_gnome_keyring=false'
    'use_gold=false'
    'use_gtk3=false'
    'use_vaapi=true'
    'use_kerberos=false'
    'use_pulseaudio=false'
    'use_sysroot=true'
    "target_sysroot=\"${SYSROOT_PREFIX}\""
    'enable_hangout_services_extension=true'
    'enable_widevine=true'
    'enable_nacl=false'
    'enable_swiftshader=false'
    "google_api_key=\"${_google_api_key}\""
    "google_default_client_id=\"${_google_default_client_id}\""
    "google_default_client_secret=\"${_google_default_client_secret}\""
  )

  # Possible replacements are listed in build/linux/unbundle/replace_gn_files.py
  local _system_libs=(
    harfbuzz-ng
    libjpeg
    libxslt
    yasm
    libxml2
    re2
    libwebp
  )

  # Remove bundled libraries for which we will use the system copies; this
  # *should* do what the remove_bundled_libraries.py script does, with the
  # added benefit of not having to list all the remaining libraries 
  local _lib
  for _lib in ${_system_libs}; do
    find -type f -path "*third_party/$_lib/*" \
      \! -path "*third_party/$_lib/chromium/*" \
      \! -path "*third_party/$_lib/google/*" \
      \! -path "*base/third_party/icu/*" \
      \! -regex '.*\.\(gn\|gni\|isolate\|py\)' \
      -delete
  done

  ./build/linux/unbundle/replace_gn_files.py --system-libraries "${_system_libs}"
  ./third_party/libaddressinput/chromium/tools/update-strings.py

  ./tools/gn/bootstrap/bootstrap.py --gn-gen-args "${_flags[*]}"
  ./out/Release/gn gen out/Release --args="${_flags[*]}" --script-executable=$ROOT/$TOOLCHAIN/bin/python

  ionice -c3 nice -n20 ninja -j4 -C out/Release chrome chrome_sandbox chromedriver widevinecdmadapter
}

makeinstall_target() {
  :
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P  $ROOT/$PKG_BUILD/out/Release/chrome $ADDON_BUILD/$PKG_ADDON_ID/bin/chromium.bin
  cp -P  $ROOT/$PKG_BUILD/out/Release/chromedriver $ADDON_BUILD/$PKG_ADDON_ID/bin/chromedriver
  cp -P  $ROOT/$PKG_BUILD/out/Release/chrome_sandbox $ADDON_BUILD/$PKG_ADDON_ID/bin/chrome-sandbox
  cp -P  $ROOT/$PKG_BUILD/out/Release/{*.pak,*.dat,*.bin,libwidevinecdmadapter.so} $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -PR $ROOT/$PKG_BUILD/out/Release/locales $ADDON_BUILD/$PKG_ADDON_ID/bin/
  cp -PR $ROOT/$PKG_BUILD/out/Release/gen/content/content_resources.pak $ADDON_BUILD/$PKG_ADDON_ID/bin/

  # config
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/config
  cp -P $PKG_DIR/config/* $ADDON_BUILD/$PKG_ADDON_ID/config

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/lib

  # pango
  cp -PL $(get_pkg_build pango)/.install_pkg/usr/lib/libpangocairo-1.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_pkg_build pango)/.install_pkg/usr/lib/libpango-1.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_pkg_build pango)/.install_pkg/usr/lib/libpangoft2-1.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # cairo
  cp -PL $(get_pkg_build cairo)/.install_pkg/usr/lib/libcairo.so.2 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # gtk
  cp -PL $(get_pkg_build gtk+)/.install_pkg/usr/lib/libgdk-x11-2.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_pkg_build gtk+)/.install_pkg/usr/lib/libgtk-x11-2.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  
#  cp -PL $(get_pkg_build gtk+)/.install_pkg/usr/lib/libgailutil-3.so* $ADDON_BUILD/$PKG_ADDON_ID/lib
#  cp -PL $(get_pkg_build gtk+)/.install_pkg/usr/lib/libgdk-3.so* $ADDON_BUILD/$PKG_ADDON_ID/lib
#  cp -PL $(get_pkg_build gtk+)/.install_pkg/usr/lib/libgtk-3.so* $ADDON_BUILD/$PKG_ADDON_ID/lib

  # harfbuzz
  cp -PL $(get_pkg_build harfbuzz)/.install_pkg/usr/lib/libharfbuzz.so* $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_pkg_build harfbuzz)/.install_pkg/usr/lib/libharfbuzz-icu.so* $ADDON_BUILD/$PKG_ADDON_ID/lib

  # gdk-pixbuf
  cp -PL $(get_pkg_build gdk-pixbuf)/.install_pkg/usr/lib/libgdk_pixbuf-2.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # pixbuf loaders
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/gdk-pixbuf-modules
  cp -PL $(get_pkg_build gdk-pixbuf)/.install_pkg/usr/lib/gdk-pixbuf-2.0/2.10.0/loaders/* $ADDON_BUILD/$PKG_ADDON_ID/gdk-pixbuf-modules

  # libexif
  cp -PL $(get_pkg_build libexif)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib
  
  # jasper
  cp -PL $(get_pkg_build jasper)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib
  
  # at-spi2-atk
  #cp -PL $(get_pkg_build at-spi2-atk)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib
  
  # at-spi2-core
  #cp -PL $(get_pkg_build at-spi2-core)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib
  
  # atk
  cp -PL $(get_pkg_build atk)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib
  
  # libXScrnSaver
  cp -PL $(get_pkg_build libXScrnSaver)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib

  # libva-vdpau-driver
  cp -PL $(get_pkg_build libva-vdpau-driver)/.install_pkg/usr/lib/va/*.so $ADDON_BUILD/$PKG_ADDON_ID/lib

  # unclutter
  cp -P $(get_pkg_build unclutter)/.install_pkg/usr/bin/unclutter $ADDON_BUILD/$PKG_ADDON_ID/bin

  # xdotool
  cp -P $(get_pkg_build xdotool)/xdotool $ADDON_BUILD/$PKG_ADDON_ID/bin
}
