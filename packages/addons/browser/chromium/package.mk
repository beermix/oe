##################################################################################
#   re2 snappy libXcursor:host  alsa-lib:host
#  "v8_snapshot_toolchain=\"//build/toolchain/linux:x64_host\""
#  https://chromereleases.googleblog.com/
#  http://svnweb.mageia.org/packages/cauldron/chromium-browser-stable/current
#  http://omahaproxy.appspot.com/
#  https://www.chromestatus.com/
#  https://bazaar.launchpad.net/~chromium-team/chromium-browser/xenial-stable/files/head:/debian?sort=date
##################################################################################

PKG_NAME="chromium"
PKG_VERSION="64.0.3282.167"
PKG_SHA256="f3308b41f241d53a269ec0c73e8512f4ac58b7aafe16967a3dba5b99abc4c455"
PKG_REV="325-gtk2-glibc26-unwind"
PKG_ARCH="x86_64"
PKG_LICENSE="Mixed"
PKG_URL="https://commondatastorage.googleapis.com/chromium-browser-official/chromium-$PKG_VERSION.tar.xz"
PKG_URL="https://gsdview.appspot.com/chromium-browser-official/chromium-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="toolchain ninja:host Python2:host"
PKG_DEPENDS_TARGET="pciutils systemd dbus libXtst libXcomposite libXcursor alsa-lib yasm nss libXScrnSaver libexif libpng atk unclutter xdotool libdrm libjpeg-turbo freetype libxslt harfbuzz gtk+ libxss libvpx opus libwebp chromium:host"
PKG_SECTION="browser"
PKG_SHORTDESC="Chromium Browser: the open-source web browser from Google"
PKG_LONGDESC="Chromium Browser ($PKG_VERSION): the open-source web browser from Google"
PKG_TOOLCHAIN="manual"
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
}

make_host() {
  export CCACHE_SLOPPINESS=time_macros
  #./tools/gn/bootstrap/bootstrap.py --no-rebuild --no-clean
  #./tools/gn/bootstrap/bootstrap.py -s --no-clean
}

make_target() {
  export CCACHE_SLOPPINESS=time_macros
  
#CFLAGS+='   -fno-unwind-tables -fno-asynchronous-unwind-tables'
#CXXFLAGS+=' -fno-unwind-tables -fno-asynchronous-unwind-tables'
#CPPFLAGS+=' -DNO_UNWIND_TABLES'

  local _google_api_key=AIzaSyAQ6L9vt9cnN4nM0weaa6Y38K4eyPvtKgI
  local _google_default_client_id=740889307901-4bkm4e0udppnp1lradko85qsbnmkfq3b.apps.googleusercontent.com
  local _google_default_client_secret=9TJlhL661hvShQub4cWhANXa

  mkdir -p $PKG_BUILD/third_party/node/linux/node-linux-x64/bin
  ln -fs /usr/bin/node $PKG_BUILD/third_party/node/linux/node-linux-x64/bin/node
  #ln -fs /home/user/.bin/node $PKG_BUILD/third_party/node/linux/node-linux-x64/bin/node

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
    'enable_linux_installer=false'
    'use_system_freetype=true'
    'exclude_unwind_tables=true'
    'linux_link_libudev = true'
    'use_system_harfbuzz=true'
    'use_v8_context_snapshot=false'
    'enable_google_now=false'
    'is_desktop_linux=true'
    'enable_vr=false'
    'enable_wayland_server=false'
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
# Keys are the names in the above script; values are the dependencies in Arch     'enable_remoting=false' 'rtc_enable_protobuf=false'
readonly -A _system_libs=(
  #[icu]=icu
  [libdrm]=
  [libjpeg]=libjpeg
  [libxml]=libxml2
  [libxslt]=libxslt
  [libvpx]=libvpx
  [libwebp]=libwebp
  [opus]=opus
  #[re2]=re2
  #[snappy]=snappy
  [yasm]=
  #[zlib]=minizip
)
readonly _unwanted_bundled_libs=(
  ${!_system_libs[@]}
  ${_system_libs[libjpeg]+libjpeg_turbo}
  freetype
  harfbuzz-ng
)
depends+=(${_system_libs[@]} freetype2 harfbuzz)

# Remove bundled libraries for which we will use the system copies; this
  # *should* do what the remove_bundled_libraries.py script does, with the
  # added benefit of not having to list all the remaining libraries -            \! -path './base/third_party/icu/*' \
  local _lib
  for _lib in ${_unwanted_bundled_libs[@]}; do
    find -type f -path "*third_party/$_lib/*" \
      \! -path "*third_party/$_lib/chromium/*" \
      \! -path "*third_party/$_lib/google/*" \
      \! -path './third_party/freetype/src/src/psnames/pstables.h' \
      \! -path './third_party/yasm/run_yasm.py' \
      \! -regex '.*\.\(gn\|gni\|isolate\)' \
      -delete
  done

  ./build/linux/unbundle/replace_gn_files.py --system-libraries "${!_system_libs[@]}"

  ./third_party/libaddressinput/chromium/tools/update-strings.py

  ./tools/gn/bootstrap/bootstrap.py -s --no-clean --gn-gen-args="${_flags[*]}"

  ./out/Release/gn gen out/Release --args="${_flags[*]}" --script-executable=$TOOLCHAIN/bin/python2

  ninja -j${CONCURRENCY_MAKE_LEVEL} $NINJA_OPTS -C out/Release chrome chrome_sandbox widevinecdmadapter
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P  $PKG_BUILD/out/Release/chrome $ADDON_BUILD/$PKG_ADDON_ID/bin/chromium.bin
  cp -P  $PKG_BUILD/out/Release/chrome_sandbox $ADDON_BUILD/$PKG_ADDON_ID/bin/chrome-sandbox
  cp -PR $PKG_BUILD/out/Release/locales $ADDON_BUILD/$PKG_ADDON_ID/bin/
  cp -PR $PKG_BUILD/out/Release/gen/content/content_resources.pak $ADDON_BUILD/$PKG_ADDON_ID/bin/

  cp -ri  $PKG_BUILD/out/Release/{*.pak,*.dat,*.bin,libwidevinecdmadapter.so} $ADDON_BUILD/$PKG_ADDON_ID/bin
  #cp -ri  $PKG_BUILD/out/Release/{*.pak,*.bin,libwidevinecdmadapter.so} $ADDON_BUILD/$PKG_ADDON_ID/bin

  # config
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/config \
           $ADDON_BUILD/$PKG_ADDON_ID/gdk-pixbuf-modules \
           $ADDON_BUILD/$PKG_ADDON_ID/lib

  # config
  cp -P $PKG_DIR/config/* $ADDON_BUILD/$PKG_ADDON_ID/config

  # atk
  cp -PL $(get_build_dir atk)/.install_pkg/usr/lib/libatk-1.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # cairo
  cp -PL $(get_build_dir cairo)/.install_pkg/usr/lib/libcairo-gobject.so.2 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir cairo)/.install_pkg/usr/lib/libcairo.so.2 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # gdk-pixbuf
  cp -PL $(get_build_dir gdk-pixbuf)/.install_pkg/usr/lib/libgdk_pixbuf-2.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # gdk-pixbuf modules
  cp -PL $(get_build_dir gdk-pixbuf)/.install_pkg/usr/lib/gdk-pixbuf-2.0/2.10.0/loaders/* $ADDON_BUILD/$PKG_ADDON_ID/gdk-pixbuf-modules

  # gtk
  cp -PL $(get_build_dir gtk+)/.install_pkg/usr/lib/libgdk-x11-2.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir gtk+)/.install_pkg/usr/lib/libgtk-x11-2.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # harfbuzz
  cp -PL $(get_build_dir harfbuzz)/.install_pkg/usr/lib/libharfbuzz.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir harfbuzz)/.install_pkg/usr/lib/libharfbuzz-icu.so* $ADDON_BUILD/$PKG_ADDON_ID/lib

  # gdk-pixbuf
  cp -PL $(get_build_dir gdk-pixbuf)/.install_pkg/usr/lib/libgdk_pixbuf-2.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # pixbuf loaders
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/gdk-pixbuf-modules
  cp -PL $(get_build_dir gdk-pixbuf)/.install_pkg/usr/lib/gdk-pixbuf-2.0/2.10.0/loaders/* $ADDON_BUILD/$PKG_ADDON_ID/gdk-pixbuf-modules

  # libXcursor
  cp -PL $(get_build_dir libXcursor)/.install_pkg/usr/lib/libXcursor.so.1 $ADDON_BUILD/$PKG_ADDON_ID/lib 

  # libxss
  cp -PL $(get_build_dir libxss)/.install_pkg/usr/lib/libXss.so.1 $ADDON_BUILD/$PKG_ADDON_ID/lib 

  # libXtst
  cp -PL $(get_build_dir libXtst)/.install_pkg/usr/lib/libXtst.so.6 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # pango
  cp -PL $(get_build_dir pango)/.install_pkg/usr/lib/libpangocairo-1.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir pango)/.install_pkg/usr/lib/libpango-1.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir pango)/.install_pkg/usr/lib/libpangoft2-1.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # unclutter
  cp -P $(get_build_dir unclutter)/.install_pkg/usr/bin/unclutter $ADDON_BUILD/$PKG_ADDON_ID/bin

  # xdotool
  cp -P $(get_build_dir xdotool)/xdotool $ADDON_BUILD/$PKG_ADDON_ID/bin

  # libXft
  cp -PL $(get_build_dir libXft)/.install_pkg/usr/lib/libXft.so.2 $ADDON_BUILD/$PKG_ADDON_ID/lib
}
