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
PKG_VERSION="65.0.3325.181"
PKG_SHA256="93666448c6b96ec83e6a35a64cff40db4eb92a154fe1db4e7dab4761d0e38687"
PKG_REV="202"
PKG_ARCH="x86_64"
PKG_LICENSE="Mixed"
PKG_SITE="http://www.chromium.org/Home"
PKG_URL="https://commondatastorage.googleapis.com/chromium-browser-official/chromium-$PKG_VERSION.tar.xz"
#PKG_URL="https://gsdview.appspot.com/chromium-browser-official/chromium-$PKG_VERSION.tar.xz"
#PKG_URL="http://192.168.1.200:8080/%2Fchromium-66.0.3359.117.tar.xz"
PKG_DEPENDS_HOST="toolchain ninja:host Python2:host gperf:host libevent:host"
PKG_DEPENDS_TARGET="pciutils dbus libXtst libXcomposite libXcursor alsa-lib bzip2 yasm nss libXScrnSaver libexif libpng atk unclutter xdotool libdrm libjpeg-turbo freetype harfbuzz gtk+ ply:host simplejson:host chromium:host"
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

  # Use Python2
  find . -name '*.py' -exec sed -i -r "s|/usr/bin/python$|$TOOLCHAIN/bin/python|g" {} +

  # set correct widevine
  sed 's|@WIDEVINE_VERSION@|The Cake Is a Lie|g' -i ./third_party/widevine/cdm/stub/widevine_cdm_version.h
  
  sed 's|//third_party/usb_ids/usb.ids|/usr/share/hwdata/usb.ids|g' -i ./device/usb/BUILD.gn
}

make_host() {
  export CCACHE_SLOPPINESS=time_macros
  ./tools/gn/bootstrap/bootstrap.py --no-rebuild --no-clean
}

make_target() {
  # unset CPPFLAGS
  # unset CFLAGS
  # unset CXXFLAGS
  # unset LDFLAGS

  # export CFLAGS="$CFLAGS -fno-unwind-tables -fno-asynchronous-unwind-tables"
  # export CXXFLAGS="$CXXFLAGS -Wno-attributes -Wno-comment -Wno-unused-variable -Wno-noexcept-type -Wno-register -Wno-strict-overflow -Wno-deprecated-declarations -fdiagnostics-color=always -fno-unwind-tables -fno-asynchronous-unwind-tables"
  # export CPPFLAGS="$CPPFLAGS -DNO_UNWIND_TABLES"
  
  export CCACHE_CPP2=yes
  export CCACHE_SLOPPINESS=time_macros

  # Allow building against system libraries in official builds
  sed -i 's/OFFICIAL_BUILD/GOOGLE_CHROME_BUILD/' ./tools/generate_shim_headers/generate_shim_headers.py

  # Work around broken screen sharing in Google Meet
  # https://crbug.com/829916#c16
  sed -i 's/"Chromium/"Chrome/' ./chrome/common/chrome_content_client_constants.cc

  # Force script incompatible with Python 3 to use /usr/bin/python2
  sed -i '1s|python$|&2|' ./third_party/dom_distiller_js/protoc_plugins/*.py
  
  # Use chromium-dev as branch name.
  sed -e 's|filename = "chromium-browser"|filename = "chromium-dev"|' \
      -e 's|confdir = "chromium|&-dev|' \
      -i ./chrome/BUILD.gn
  sed -e 's|config_dir.Append("chromium|&-dev|' \
      -i ./chrome/common/chrome_paths_linux.cc
  sed -e 's|/etc/chromium|&-dev|' \
      -e 's|/usr/share/chromium|&-dev|' \
      -i ./chrome/common/chrome_paths.cc
  sed -e 's|/etc/chromium|&-dev|' \
      -i ./components/policy/tools/template_writers/writer_configuration.py

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
    'link_pulseaudio=false'
    'linux_use_bundled_binutils=false'
    'use_cups=false'
    'use_custom_libcxx=false'
    'use_gnome_keyring=false'
    'use_gold=false'
    'use_gtk3=false'
    'use_kerberos=false'
    'use_pulseaudio=false'
    'use_allocator="none"'
    'enable_google_now=false'
    'enable_mdns=true'
    'enable_nacl=false'
    'enable_vr=false'
    'is_desktop_linux=true'
    'use_dbus=true'
    'use_glib=true'
    'use_libpci=true'
    'rtc_enable_protobuf=false'
    'optimize_webui=false'
    'target_cpu="x64"'
    'linux_link_libudev=true'
    'enable_print_preview=false'
    'enable_remoting=false'
    'headless_use_embedded_resources=true'
    'use_sysroot=true'
    'use_vaapi=true'
    'use_v8_context_snapshot=false'
    'enable_hangout_services_extension=false'
    'enable_nacl=false'
    'enable_swiftshader=false'
    "target_sysroot=\"${SYSROOT_PREFIX}\""
    'use_jumbo_build=true' # https://chromium.googlesource.com/chromium/src/+/lkcr/docs/jumbo.md
    'enable_nacl_nonsfi=false'
    'enable_vulkan=false'
    "google_api_key=\"${_google_api_key}\""
    "google_default_client_id=\"${_google_default_client_id}\""
    "google_default_client_secret=\"${_google_default_client_secret}\""
  )

# Possible replacements are listed in build/linux/unbundle/replace_gn_files.py
# Keys are the names in the above script; values are the dependencies in Arch
declare -gA _system_libs=(
  [fontconfig]=fontconfig
  [freetype]=freetype2
  [harfbuzz-ng]=harfbuzz
  [icu]=icu
  [libdrm]=
  [libjpeg]=libjpeg
#  [libpng]=libpng            # https://crbug.com/752403#c10
#  [libvpx]=libvpx
#  [libwebp]=libwebp
#  [libxml]=libxml2           # https://crbug.com/736026
  [libxslt]=libxslt
#  [re2]=re2
#  [snappy]=snappy
  [yasm]=
  [zlib]=minizip
)
_unwanted_bundled_libs=(
  ${!_system_libs[@]}
  ${_system_libs[libjpeg]+libjpeg_turbo}
)
depends+=(${_system_libs[@]})

# Force script incompatible with Python 3 to use $TOOLCHAIN/bin/python
   sed -i '1s|python$|&2|' \
     -i ./build/download_nacl_toolchains.py \
     -i ./build/linux/unbundle/remove_bundled_libraries.py \
     -i ./build/linux/unbundle/replace_gn_files.py \
     -i ./tools/clang/scripts/update.py \
     -i ./tools/gn/bootstrap/bootstrap.py \
     -i ./third_party/dom_distiller_js/protoc_plugins/*.py \
     -i ./third_party/ffmpeg/chromium/scripts/build_ffmpeg.py \
     -i ./third_party/ffmpeg/chromium/scripts/generate_gn.py
   export PNACLPYTHON=$TOOLCHAIN/bin/python

# Setup vulkan
# export VULKAN_SDK="/usr"
# sed 's|/x86_64-linux-gnu||' -i ./gpu/vulkan/BUILD.gn

# Remove bundled libraries for which we will use the system copies; this
# *should* do what the remove_bundled_libraries.py script does, with the
# added benefit of not having to list all the remaining libraries
local _lib
  for _lib in ${_unwanted_bundled_libs[@]}; do
    find -type f -path "*third_party/$_lib/*" \
      \! -path "*third_party/$_lib/chromium/*" \
      \! -path "*third_party/$_lib/google/*" \
      \! -path './base/third_party/icu/*' \
      \! -path './third_party/pdfium/third_party/freetype/include/pstables.h' \
      \! -path './third_party/yasm/run_yasm.py' \
      \! -regex '.*\.\(gn\|gni\|isolate\)' \
      -delete
  done

  ./build/linux/unbundle/replace_gn_files.py --system-libraries "${!_system_libs[@]}"
  ./third_party/libaddressinput/chromium/tools/update-strings.py

  ./out/Release/gn gen out/Release --args="${_flags[*]}" --script-executable=$TOOLCHAIN/bin/python

 # ionice -c3 nice -n20 ninja -j${CONCURRENCY_MAKE_LEVEL} $NINJA_OPTS -C out/Release media
 #  ionice -c3 nice -n20 ninja -j${CONCURRENCY_MAKE_LEVEL} $NINJA_OPTS -C out/Headless headless_shell

  ionice -c3 nice -n20 ninja -j3 $NINJA_OPTS -C out/Release chrome chrome_sandbox
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P  $PKG_BUILD/out/Release/chrome $ADDON_BUILD/$PKG_ADDON_ID/bin/chromium.bin
  cp -P  $PKG_BUILD/out/Release/chrome_sandbox $ADDON_BUILD/$PKG_ADDON_ID/bin/chrome-sandbox
  cp -P  $PKG_BUILD/out/Release/{*.pak,*.bin} $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -PR $PKG_BUILD/out/Release/locales $ADDON_BUILD/$PKG_ADDON_ID/bin/
  cp -PR $PKG_BUILD/out/Release/gen/content/content_resources.pak $ADDON_BUILD/$PKG_ADDON_ID/bin/

  # config *.dat,
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/config
  cp -P $PKG_DIR/config/* $ADDON_BUILD/$PKG_ADDON_ID/config

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/lib

  # pango
  cp -PL $(get_build_dir pango)/.install_pkg/usr/lib/libpangocairo-1.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir pango)/.install_pkg/usr/lib/libpangocairo-1.0.so $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir pango)/.install_pkg/usr/lib/libpango-1.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir pango)/.install_pkg/usr/lib/libpangoft2-1.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # cairo
  cp -PL $(get_build_dir cairo)/.install_pkg/usr/lib/libcairo.so.2 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir cairo)/.install_pkg/usr/lib/libcairo-gobject.so.2 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # atk
  cp -ri $(get_build_dir atk)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib

  # gtk
  cp -PL $(get_build_dir gtk+)/.install_pkg/usr/lib/libgdk-x11-2.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir gtk+)/.install_pkg/usr/lib/libgtk-x11-2.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # harfbuzz
  cp -PL $(get_build_dir harfbuzz)/.install_pkg/usr/lib/libharfbuzz.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir harfbuzz)/.install_pkg/usr/lib/libharfbuzz-icu.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir harfbuzz)/.install_pkg/usr/lib/libharfbuzz-gobject.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir harfbuzz)/.install_pkg/usr/lib/libharfbuzz-subset.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # gdk-pixbuf
  cp -PL $(get_build_dir gdk-pixbuf)/.install_pkg/usr/lib/libgdk_pixbuf-2.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # pixbuf loaders
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/gdk-pixbuf-modules
  cp -PL $(get_build_dir gdk-pixbuf)/.install_pkg/usr/lib/gdk-pixbuf-2.0/2.10.0/loaders/* $ADDON_BUILD/$PKG_ADDON_ID/gdk-pixbuf-modules

  # libexif
  cp -ri $(get_build_dir libexif)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib

  # unclutter
  cp -P $(get_build_dir unclutter)/.install_pkg/usr/bin/unclutter $ADDON_BUILD/$PKG_ADDON_ID/bin

  # xdotool
  cp -P $(get_build_dir xdotool)/xdotool $ADDON_BUILD/$PKG_ADDON_ID/bin
}
