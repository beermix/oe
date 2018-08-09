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
################################################################################

PKG_NAME="chromium"
PKG_VERSION="67.0.3396.10"
#PKG_SHA256="77c5a334644fdc303697b3864c9a6b709cee23ee384f4134308e820af4568ed6"
PKG_REV="202-dev"
PKG_ARCH="x86_64"
PKG_LICENSE="Mixed"
PKG_SITE="http://www.chromium.org/Home"
PKG_URL="https://commondatastorage.googleapis.com/chromium-browser-official/chromium-$PKG_VERSION.tar.xz"
#PKG_URL="https://gsdview.appspot.com/chromium-browser-official/chromium-$PKG_VERSION.tar.xz"
#PKG_URL="http://192.168.1.200:8080/%2Fchromium-66.0.3359.117.tar.xz"
PKG_DEPENDS_HOST="toolchain ninja:host Python2:host"
PKG_DEPENDS_TARGET="pciutils dbus libXtst libXcomposite libXcursor alsa-lib bzip2 yasm nss libXScrnSaver libexif libpng atk unclutter xdotool libdrm libjpeg-turbo freetype harfbuzz gtk+ re2 snappy chromium:host"
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
  
  # ssed 's|//third_party/usb_ids/usb.ids|/usr/share/hwdata/usb.ids|g' -i ./device/usb/BUILD.gn
}

make_host() {
  export CCACHE_CPP2=yes
  export CCACHE_SLOPPINESS=time_macros
  ./tools/gn/bootstrap/bootstrap.py --no-rebuild --no-clean
}

make_target() {
  unset CPPFLAGS
  unset CFLAGS
  unset CXXFLAGS
  unset LDFLAGS

  export CFLAGS="$CFLAGS -fno-unwind-tables -fno-asynchronous-unwind-tables"
  export CXXFLAGS="$CXXFLAGS -Wno-attributes -Wno-comment -Wno-unused-variable -Wno-noexcept-type -Wno-register -Wno-strict-overflow -Wno-deprecated-declarations -fdiagnostics-color=always -fno-unwind-tables -fno-asynchronous-unwind-tables"
  export CPPFLAGS="$CPPFLAGS -DNO_UNWIND_TABLES"

  export CFLAGS="$CFLAGS -Wno-builtin-macro-redefined"
  export CXXFLAGS="$CXXFLAGS -Wno-builtin-macro-redefined"
  export CPPFLAGS="$CPPFLAGS -D__DATE__=  -D__TIME__=  -D__TIMESTAMP__="

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
    'use_allocator="none"'
    'use_cups=false'
    'use_custom_libcxx=false'
    'use_gnome_keyring=false'
    'use_gold=false'
    'use_gtk3=false'
    'use_kerberos=false'
    'use_pulseaudio=false'
    'linux_link_libudev=true'
    'use_sysroot=true'
    'use_vaapi=true'
    'use_v8_context_snapshot=false'
    'enable_hangout_services_extension=true'
    'enable_nacl=false'
    'enable_swiftshader=false'
    "target_sysroot=\"${SYSROOT_PREFIX}\""
    'use_jumbo_build=false' # https://chromium.googlesource.com/chromium/src/+/lkcr/docs/jumbo.md
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
#  [icu]=icu
  [libdrm]=
  [libjpeg]=libjpeg
#  [libpng]=libpng            # https://crbug.com/752403#c10
#  [libvpx]=libvpx
#  [libwebp]=libwebp
#  [libxml]=libxml2           # https://crbug.com/736026
  [libxslt]=libxslt
  [re2]=re2
  [snappy]=snappy
  [yasm]=
  [zlib]=minizip
)
_unwanted_bundled_libs=(
  ${!_system_libs[@]}
  ${_system_libs[libjpeg]+libjpeg_turbo}
)
depends+=(${_system_libs[@]})

# Force script incompatible with Python 3 to use /usr/bin/python2
   sed -i '1s|python$|&2|' \
     -i build/download_nacl_toolchains.py \
     -i build/linux/unbundle/remove_bundled_libraries.py \
     -i build/linux/unbundle/replace_gn_files.py \
     -i tools/clang/scripts/update.py \
     -i tools/gn/bootstrap/bootstrap.py \
     -i third_party/dom_distiller_js/protoc_plugins/*.py \
     -i third_party/ffmpeg/chromium/scripts/build_ffmpeg.py \
     -i third_party/ffmpeg/chromium/scripts/generate_gn.py
   export PNACLPYTHON=$TOOLCHAIN/bin/python

# Setup vulkan
# export VULKAN_SDK="/usr"
# sed 's|/x86_64-linux-gnu||' -i ./gpu/vulkan/BUILD.gn

_keeplibs=(
           'base/third_party/dmg_fp'
           'base/third_party/dynamic_annotations'
           'base/third_party/icu'
           'base/third_party/nspr'
           'base/third_party/superfasthash'
           'base/third_party/symbolize'
           'base/third_party/valgrind'
           'base/third_party/xdg_mime'
           'base/third_party/xdg_user_dirs'
           'buildtools/third_party/libc++'
           'buildtools/third_party/libc++abi'
           'chrome/third_party/mozilla_security_manager'
           'courgette/third_party'
           'native_client/src/third_party/dlmalloc'
           'native_client_sdk/src/libraries/third_party/newlib-extras'
           'net/third_party/mozilla_security_manager'
           'net/third_party/nss'
           'third_party/WebKit'
           'third_party/analytics'
           'third_party/angle'
           'third_party/angle/src/common/third_party/base'
           'third_party/angle/src/common/third_party/smhasher'
           'third_party/angle/src/third_party/compiler'
           'third_party/angle/src/third_party/libXNVCtrl'
           'third_party/angle/src/third_party/trace_event'
           'third_party/angle/third_party/glslang'
           'third_party/angle/third_party/spirv-headers'
           'third_party/angle/third_party/spirv-tools'
           'third_party/angle/third_party/vulkan-validation-layers'
           'third_party/apple_apsl'
           'third_party/blink'
           'third_party/boringssl'
           'third_party/boringssl/src/third_party/fiat'
           'third_party/breakpad'
           'third_party/breakpad/breakpad/src/third_party/curl'
           'third_party/brotli'
           'third_party/cacheinvalidation'
           'third_party/catapult'
           'third_party/catapult/common/py_vulcanize/third_party/rcssmin'
           'third_party/catapult/common/py_vulcanize/third_party/rjsmin'
           'third_party/catapult/third_party/polymer'
           'third_party/catapult/tracing/third_party/d3'
           'third_party/catapult/tracing/third_party/gl-matrix'
           'third_party/catapult/tracing/third_party/jszip'
           'third_party/catapult/tracing/third_party/mannwhitneyu'
           'third_party/catapult/tracing/third_party/oboe'
           'third_party/catapult/tracing/third_party/pako'
           'third_party/ced'
           'third_party/cld_3'
           'third_party/crashpad'
           'third_party/crashpad/crashpad/third_party/zlib'
           'third_party/crc32c'
           'third_party/cros_system_api'
           'third_party/devscripts'
           'third_party/dom_distiller_js'
           'third_party/fips181'
           'third_party/flatbuffers'
           'third_party/flot'
           'third_party/glslang'
           'third_party/glslang-angle'
           'third_party/google_input_tools'
           'third_party/google_input_tools/third_party/closure_library'
           'third_party/google_input_tools/third_party/closure_library/third_party/closure'
           'third_party/googletest'
           'third_party/hunspell'
           'third_party/iccjpeg'
           'third_party/inspector_protocol'
           'third_party/jinja2'
           'third_party/jstemplate'
           'third_party/khronos'
           'third_party/leveldatabase'
           'third_party/libXNVCtrl'
           'third_party/libaddressinput'
           'third_party/libaom'
           'third_party/libjingle'
           'third_party/libphonenumber'
           'third_party/libsecret'
           'third_party/libsrtp'
           'third_party/libudev'
           'third_party/libxml/chromium'
           'third_party/libyuv'
           'third_party/llvm'
           'third_party/lss'
           'third_party/lzma_sdk'
           'third_party/markupsafe'
           'third_party/mesa'
           'third_party/metrics_proto'
           'third_party/modp_b64'
           'third_party/node'
           'third_party/node/node_modules/polymer-bundler/lib/third_party/UglifyJS2'
           'third_party/openmax_dl'
           'third_party/ots'
           'third_party/pdfium'
           'third_party/pdfium/third_party/agg23'
           'third_party/pdfium/third_party/base'
           'third_party/pdfium/third_party/bigint'
           'third_party/pdfium/third_party/eu-strip'
           'third_party/pdfium/third_party/freetype'
           'third_party/pdfium/third_party/lcms'
           'third_party/pdfium/third_party/libopenjpeg20'
           'third_party/pdfium/third_party/libpng16'
           'third_party/pdfium/third_party/libtiff'
           'third_party/pdfium/third_party/skia_shared'
           'third_party/ply'
           'third_party/polymer'
           'third_party/protobuf'
           'third_party/protobuf/third_party/six'
           'third_party/qcms'
           'third_party/s2cellid'
           'third_party/sfntly'
           'third_party/shaderc'
           'third_party/skia'
           'third_party/skia/third_party/gif'
           'third_party/skia/third_party/spirv-headers'
           'third_party/skia/third_party/spirv-tools'
           'third_party/skia/third_party/vulkan'
           'third_party/smhasher'
           'third_party/spirv-headers'
           'third_party/SPIRV-Tools'
           'third_party/spirv-tools-angle'
           'third_party/sqlite'
           'third_party/swiftshader'
           'third_party/swiftshader/third_party/llvm-subzero'
           'third_party/swiftshader/third_party/subzero'
           'third_party/tcmalloc'
           'third_party/unrar'
           'third_party/usrsctp'
           'third_party/vulkan-validation-layers'
           'third_party/vulkan'
           'third_party/web-animations-js'
           'third_party/webdriver'
           'third_party/webrtc'
           'third_party/widevine'
           'third_party/woff2'
           'third_party/zlib/google'

           'url/third_party/mozilla'
           'v8/src/third_party/valgrind'
           'v8/src/third_party/utf8-decoder'
           'v8/third_party/inspector_protocol'

           # gyp -> gn leftovers
           'base/third_party/libevent'
           'third_party/adobe'
           'third_party/speech-dispatcher'
           'third_party/usb_ids'
           'third_party/xdg-utils'
           )

_keeplibs+=(
            'third_party/icu'
            )

#  ./build/linux/unbundle/remove_bundled_libraries.py ${_keeplibs[@]} --do-remove
  ./build/linux/unbundle/replace_gn_files.py --system-libraries "${!_system_libs[@]}"
  ./third_party/libaddressinput/chromium/tools/update-strings.py

  ./out/Release/gn gen out/Release --args="${_flags[*]}" --script-executable=$TOOLCHAIN/bin/python

  LC_ALL=C ionice -c3 nice -n20 noti ninja -j${CONCURRENCY_MAKE_LEVEL} -C out/Release chrome chrome_sandbox
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
  cp -PL $(get_build_dir pango)/.install_pkg/usr/lib/libpangocairo-1.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir pango)/.install_pkg/usr/lib/libpangocairo-1.0.so $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir pango)/.install_pkg/usr/lib/libpango-1.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir pango)/.install_pkg/usr/lib/libpangoft2-1.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # cairo
  cp -PL $(get_build_dir cairo)/.install_pkg/usr/lib/libcairo.so.2 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir cairo)/.install_pkg/usr/lib/libcairo-gobject.so.2 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # libwebp
  # cp -ri $(get_build_dir libwebp)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib

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
