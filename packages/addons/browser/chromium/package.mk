##################################################################################
#  "v8_snapshot_toolchain=\"//build/toolchain/linux:x64_host\""
#  https://chromereleases.googleblog.com/
#  http://svnweb.mageia.org/packages/cauldron/chromium-browser-stable/current
#  http://omahaproxy.appspot.com/
#  https://www.chromestatus.com/
#  https://bazaar.launchpad.net/~chromium-team/chromium-browser/xenial-stable/files/head:/debian?sort=date
################################################################################## =  opus re2 snappy

PKG_NAME="chromium"
PKG_VERSION="68.0.3440.75"
PKG_SHA256="dc17783267853bdc0fb726363d2b8e30a0bf43b6cc2c768e1f37c92e8eb59541"
PKG_VERSION="66.0.3359.170"
PKG_SHA256="864da6649d19387698e3a89321042193708b2d9f56b3a778fb552166374871de"
PKG_VERSION="64.0.3282.186"
PKG_SHA256="5fd0218759231ac00cc729235823592f6fd1e4a00ff64780a5fed7ab210f1860"
PKG_REV="460-glibc28.900-gcc8+re2+snappy+libxml2"
PKG_ARCH="x86_64"
PKG_LICENSE="Mixed"
PKG_URL="https://commondatastorage.googleapis.com/chromium-browser-official/chromium-$PKG_VERSION.tar.xz"
PKG_URL="https://gsdview.appspot.com/chromium-browser-official/chromium-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="toolchain ninja:host Python2:host"
PKG_DEPENDS_TARGET="pciutils dbus libXtst libXcomposite libXcursor unclutter alsa-lib bzip2 yasm nss libXScrnSaver libexif libpng atk xdotool libdrm libjpeg-turbo freetype libxslt harfbuzz gtk+ libxss re2 snappy chromium:host"
PKG_SECTION="browser"
PKG_SHORTDESC="Chromium Browser: the open-source web browser from Google"
PKG_TOOLCHAIN="manual"
PKG_BUILD_FLAGS="-lto -hardening"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="Chromium"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES="executable"

post_patch() {
  cd $(get_build_dir chromium)

  # Use Python 2
  find . -name '*.py' -exec sed -i -r "s|/usr/bin/python$|$TOOLCHAIN/bin/python|g" {} +

  # set correct widevine
  # sed -i -e 's/@WIDEVINE_VERSION@/Pinkie Pie/' ./third_party/widevine/cdm/stub/widevine_cdm_version.h
}

make_host() {
  export CCACHE_SLOPPINESS=time_macros
  ./tools/gn/bootstrap/bootstrap.py --no-rebuild --no-clean
}

make_target() {
  unset CPPFLAGS
  unset CFLAGS
  unset CXXFLAGS
  unset LDFLAGS

  export CCACHE_SLOPPINESS=time_macros

  export CFLAGS="$CFLAGS -fdiagnostics-color=always"
  export CXXFLAGS="$CXXFLAGS -fdiagnostics-color=always"
  export LDFLAGS="$LDFLAGS -fuse-ld=gold"

  local _google_api_key=AIzaSyAQ6L9vt9cnN4nM0weaa6Y38K4eyPvtKgI
  local _google_default_client_id=740889307901-4bkm4e0udppnp1lradko85qsbnmkfq3b.apps.googleusercontent.com
  local _google_default_client_secret=9TJlhL661hvShQub4cWhANXa

  mkdir -p $PKG_BUILD/third_party/node/linux/node-linux-x64/bin
  ln -fs /usr/bin/node $PKG_BUILD/third_party/node/linux/node-linux-x64/bin/node

  local _flags=(
    "host_toolchain=\"//build/toolchain/linux:x64_host\""
    'is_clang=false'
    'use_cfi_icall=false'
    'clang_use_chrome_plugins=false'
    'symbol_level=0'
    'is_debug=false'
    'fatal_linker_warnings=false'
    'treat_warnings_as_errors=false'
    'fieldtrial_testing_like_official_build=true'
    'remove_webcore_debug_symbols=true'
    'ffmpeg_branding="Chrome"'
    'proprietary_codecs=true'
    'linux_use_bundled_binutils=false'
    'use_allocator="none"'
    'use_cups=false'
    'use_system_freetype=true'
    'use_system_harfbuzz=true'
    'use_custom_libcxx=false'
    'use_gconf=false'
    'use_gnome_keyring=false'
    'use_gold=false'
    'use_kerberos=false'
    'use_gtk3=false'
    'use_pulseaudio=false'
    'use_sysroot=true'
    'linux_link_libgio=true'
    'linux_link_libudev = true'
    'use_libpci = true'
    'linux_link_libspeechd = false'
    'pdf_enable_xfa=false'
    'exclude_unwind_tables=true'
    'enable_ac3_eac3_audio_demuxing=true'
    'enable_mse_mpeg2ts_stream_parser=true'
    'enable_hevc_demuxing=true'
    'enable_google_now=false'
    'is_desktop_linux=true'
    'use_v8_context_snapshot=false'
    "target_sysroot=\"${SYSROOT_PREFIX}\""
    'enable_widevine=false'
    'use_vaapi=true'
    'use_dbus=true'
    'use_system_zlib=true'
    'use_system_libjpeg=true'
    'use_gio=true'
    'use_udev=true'
    'icu_use_data_file=false'
    'enable_remoting=false'
    'enable_print_preview=false'
    'enable_vr=false'
    'enable_vulkan=false'
    'enable_nacl=false'
    'enable_nacl_nonsfi=false'
    'enable_swiftshader=false'
    'enable_hangout_services_extension=false'
    'enable_wayland_server=false'
    "google_api_key=\"${_google_api_key}\""
    "google_default_client_id=\"${_google_default_client_id}\""
    "google_default_client_secret=\"${_google_default_client_secret}\""
  )

# Possible replacements are listed in build/linux/unbundle/replace_gn_files.py ## 'enable_webrtc=false'
# Keys are the names in the above script; values are the dependencies in Arch
readonly -A _system_libs=(
  [icu]=icu
  [libdrm]=
  [icu]=icu
  [libjpeg]=libjpeg
  [libxml]=libxml2           # https://crbug.com/736026
  [libxslt]=libxslt
  [re2]=re2
  [snappy]=snappy
  [yasm]=
  [zlib]=minizip
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
  # added benefit of not having to list all the remaining libraries ||  
  local _lib
  for _lib in ${_unwanted_bundled_libs[@]}; do
    find -type f -path "*third_party/$_lib/*" \
      \! -path "*third_party/$_lib/chromium/*" \
      \! -path "*third_party/$_lib/google/*" \
      \! -path './base/third_party/icu/*' \
      \! -path './third_party/freetype/src/src/psnames/pstables.h' \
      \! -path './third_party/yasm/run_yasm.py' \
      \! -regex '.*\.\(gn\|gni\|isolate\)' \
      -delete
  done

  ./build/linux/unbundle/replace_gn_files.py --system-libraries "${!_system_libs[@]}"

  ./third_party/libaddressinput/chromium/tools/update-strings.py

  ./out/Release/gn gen out/Release --args="${_flags[*]}" --script-executable=$TOOLCHAIN/bin/python

  ionice -c3 nice -n20 ninja $NINJA_OPTS -C out/Release chrome chrome_sandbox
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P  $PKG_BUILD/out/Release/chrome $ADDON_BUILD/$PKG_ADDON_ID/bin/chromium.bin
  cp -P  $PKG_BUILD/out/Release/chrome_sandbox $ADDON_BUILD/$PKG_ADDON_ID/bin/chrome-sandbox
  cp -ri  $PKG_BUILD/out/Release/{*.pak,*.bin,*.dat} $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -PR $PKG_BUILD/out/Release/locales $ADDON_BUILD/$PKG_ADDON_ID/bin/
  cp -PR $PKG_BUILD/out/Release/gen/content/content_resources.pak $ADDON_BUILD/$PKG_ADDON_ID/bin/

  # config *.dat, ,libwidevinecdmadapter.so ++  
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
  cp -PL $(get_build_dir libXft)/.install_pkg/usr/lib/libXft.so.* $ADDON_BUILD/$PKG_ADDON_ID/lib

  # re2
  # cp -PL $(get_build_dir re2)/.install_pkg/usr/lib/libre2.so* $ADDON_BUILD/$PKG_ADDON_ID/lib

  # snappy
  # cp -PL $(get_build_dir snappy)/.install_pkg/usr/lib/libsnappy.so.* $ADDON_BUILD/$PKG_ADDON_ID/lib

  # icu
  cp -PL $(get_build_dir icu)/.install_pkg/usr/lib/libicuuc.so* $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir icu)/.install_pkg/usr/lib/libicudata.so* $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir icu)/.install_pkg/usr/lib/libicui18n.so* $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir icu)/.install_pkg/usr/lib/libicuio.so* $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir icu)/.install_pkg/usr/lib/libicutu.so* $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir icu)/.install_pkg/usr/lib/libicutest.so* $ADDON_BUILD/$PKG_ADDON_ID/lib
}
