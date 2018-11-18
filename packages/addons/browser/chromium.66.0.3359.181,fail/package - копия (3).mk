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
PKG_VERSION="66.0.3359.139"
#PKG_SHA256="37e6673741b365a25a837217b08f77b24b4f5fc4ad88c8581be6a5dae9a9e919"
PKG_REV="205"
PKG_ARCH="x86_64"
PKG_LICENSE="Mixed"
PKG_SITE="http://www.chromium.org/Home"
PKG_URL="https://commondatastorage.googleapis.com/chromium-browser-official/chromium-$PKG_VERSION.tar.xz"
#PKG_URL="https://gsdview.appspot.com/chromium-browser-official/chromium-$PKG_VERSION.tar.xz"
#PKG_URL="http://192.168.1.200:8080/%2Fchromium-66.0.3359.117.tar.xz"
PKG_DEPENDS_HOST="toolchain ninja:host Python2:host gperf:host libevent:host"
PKG_DEPENDS_HOST="toolchain ninja:host Python2:host gperf:host"
PKG_DEPENDS_TARGET="pciutils systemd dbus libXtst libXcomposite libXcursor alsa-lib bzip2 yasm nss libXScrnSaver libexif libpng atk unclutter xdotool libdrm libjpeg-turbo freetype libxslt harfbuzz gtk+ re2 snappy chromium:host"
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
  # sed 's|@WIDEVINE_VERSION@|The Cake Is a Lie|g' -i ./third_party/widevine/cdm/stub/widevine_cdm_version.h
  sed -i -e 's/@WIDEVINE_VERSION@/Pinkie Pie/' ./third_party/widevine/cdm/stub/widevine_cdm_version.h
  
  # files we do not want from upstream source bundles
rm -rf breakpad/src/processor/testdata/
rm -rf chrome/app/test_data/dlls/
rm -rf chrome/common/extensions/docs/
rm -rf ./chrome/test/data/{android,app_shim,apptest,ash,autofill,automation,automation_proxy_snapshot,banners,bookmark_html_reader,bookmarks,captive_portal,chromedriver,chrome_endure,chromeos,chromeproxy,cld2_component,click_modifier,components,constrained_files,content,content_setting_bubble,devtools,diagnostics,dom_automation,dom_checker,dom_distiller,downloads,drive_first_run,dromaeo,durable,edge_database_reader,edge_profile,encoding_tests,extensions,fast_shutdown,fast_tab_close,favicon,feeds,file_select_helper,find_in_page,firefox320_profile,firefox35_profile,firefox3_nss,firefox3_nss_mac,firefox3_profile,firefox_profile,firefox_searchplugins,focus,frame_dom_access,frame_tree,ftp,fullscreen_mouselock,geolocation,google,gpu,History,image_decoding,image_search,import,indexeddb,inspector,installer,interstitial_page,keyboard,login,native_messaging,navigation_interception,notifications,page_cycler,page_load_metrics,panels,password,pdf,pepper,perf,permissions,plugin_power_saver,policy,popup_blocker,predictor,prefs,pref_service,prerender,printing,profiles,push_messaging,referrer_policy,requirements_checker,safe_browsing,SafeBrowsing,save_page,scroll,sdch,search,session_history,session_restore,sessions,settings,speech,ssl,subresource_filter,sunspider,sync,template_url_scraper,textinput,third_party,top_sites,translate,unit,v8_benchmark_v6,viewsource,web_app_info,webapps,webrtc,websocket,webui_test_resources.grd,whitelists,workers}
rm -rf ./chrome/test/data/nacl/{pnacl_error_handling,cross_origin,irt_exception,pnacl_request_header,nonsfi,pnacl_url_loader,pnacl_hw_eh_disabled,pnacl_nmf_options,pnacl_dyncode_syscall_disabled,extension_mime_handler,ppapi_test_lib,bad,ppapi,ppapi/ppb_instance,ppapi/ppp_instance,ppapi/ppb_core,manifest,manifest/mdir,manifest/ndir,pnacl_debug_url,nacl_test_data.gyp,extension_validation_cache,exit_status,progress_events,manifest_file,sysconf_nprocessors_onln,crash,pnacl_mime_type}
rmdir ./chrome/test/data/webui/{settings,extensions}/a11y
rmdir ./chrome/test/data/webui/{engagement,extensions,media_router,print_preview,cr_elements,settings,md_bookmarks,md_downloads,md_history,md_user_manager,net_internals}
rm -rf ./chrome/tools/test/reference_build/chrome_linux/
rm -rf ./components/test/data/component_updater/jebgalgnebhfojomionfpkfelancnnkf/component1.dll
rm -rf ./content/test/data/
#rm -rf net/data/
# v the root BUILD.gn includes files from this dir
#rm -rf ppapi/examples/
rm -rf ./ppapi/native_client/tests/
rm -rf ./third_party/apache-win32/
rm -rf ./third_party/binutils/
rm -rf ./third_party/expat/files/
#rm -rf ./third_party/freetype/{src,include}
#rm -rf ./third_party/icu/{android,linux,mac,patches,public,source,windows}
rm -rf ./third_party/lcov
#rm -rf base/third_party/libevent/*/*
#rm -rf base/third_party/libevent/*.[ch]

}

make_host() {
  ./tools/gn/bootstrap/bootstrap.py --no-rebuild --no-clean
}

make_target() {
  unset CPPFLAGS
  unset CFLAGS
  unset CXXFLAGS
  unset LDFLAGS

#  export CFLAGS="$CFLAGS -fno-unwind-tables -fno-asynchronous-unwind-tables"
#  export CXXFLAGS="$CXXFLAGS -Wno-attributes -Wno-comment -Wno-unused-variable -Wno-noexcept-type -Wno-register -Wno-strict-overflow -Wno-deprecated-declarations -fdiagnostics-color=always -fno-unwind-tables -fno-asynchronous-unwind-tables"
#  export CPPFLAGS="$CPPFLAGS -DNO_UNWIND_TABLES"
  export CXXFLAGS="$CXXFLAGS -Wno-error=attributes -Wno-error=comment -Wno-error=unused-variable -Wno-error=noexcept-type -Wno-error=register -Wno-error=strict-overflow -Wno-error=deprecated-declarations"

   export CCACHE_SLOPPINESS=time_macros
  # export CCACHE_SLOPPINESS=file_macro,time_macros,include_file_mtime,include_file_ctime

  # Allow building against system libraries in official builds
  sed -i 's/OFFICIAL_BUILD/GOOGLE_CHROME_BUILD/' ./tools/generate_shim_headers/generate_shim_headers.py

  # Work around broken screen sharing in Google Meet
  # https://crbug.com/829916#c16
  sed -i 's/"Chromium/"Chrome/' ./chrome/common/chrome_content_client_constants.cc

  # Force script incompatible with Python 3 to use /usr/bin/python2
  # sed -i '1s|python$|&2|' ./third_party/dom_distiller_js/protoc_plugins/*.py
  
  # Use chromium-dev as branch name.
#  sed -e 's|filename = "chromium-browser"|filename = "chromium-dev"|' \
#      -e 's|confdir = "chromium|&-dev|' \
#      -i ./chrome/BUILD.gn
#  sed -e 's|config_dir.Append("chromium|&-dev|' \
#      -i ./chrome/common/chrome_paths_linux.cc
#  sed -e 's|/etc/chromium|&-dev|' \
#      -e 's|/usr/share/chromium|&-dev|' \
#      -i ./chrome/common/chrome_paths.cc
#  sed -e 's|/etc/chromium|&-dev|' \
#      -i ./components/policy/tools/template_writers/writer_configuration.py

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
    'use_gnome_keyring=false'
    'use_gold=false'
    'use_gtk3=false'
    'use_kerberos=false'
    'use_pulseaudio=false'
    'use_sysroot=true'
    'use_vaapi=true'
    'linux_link_libudev=true'
    'use_system_libjpeg=true'
    'use_libjpeg_turbo=false'
    'use_libpci=true'
    'use_system_freetype=true'
    'use_system_harfbuzz=true'
    'use_system_libpng=true'
    'use_v8_context_snapshot=false'
    "target_sysroot=\"${SYSROOT_PREFIX}\""
    'enable_hangout_services_extension=true'
    'enable_widevine=true'
    'enable_nacl=false'
    'use_jumbo_build=false' # https://chromium.googlesource.com/chromium/src/+/lkcr/docs/jumbo.md
    'enable_nacl_nonsfi=false'
    'enable_swiftshader=false'
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

  # Remove bundled libraries for which we will use the system copies; this
  # *should* do what the remove_bundled_libraries.py script does, with the
  # added benefit of not having to list all the remaining libraries
  local _lib
  for _lib in ${_unwanted_bundled_libs[@]}; do
    find -type f -path "*third_party/$_lib/*" \
      \! -path "*third_party/$_lib/chromium/*" \
      \! -path "*third_party/$_lib/google/*" \
      \! -path './third_party/pdfium/third_party/freetype/include/pstables.h' \
      \! -path './third_party/yasm/run_yasm.py' \
      \! -regex '.*\.\(gn\|gni\|isolate\)' \
      -delete
  done

  ./build/linux/unbundle/replace_gn_files.py --system-libraries "${!_system_libs[@]}"

  ./third_party/libaddressinput/chromium/tools/update-strings.py

  ./out/Release/gn gen out/Release --args="${_flags[*]}" --script-executable=$TOOLCHAIN/bin/python

  ionice -c3 nice -n20 ninja -j${CONCURRENCY_MAKE_LEVEL} $NINJA_OPTS -C out/Release chrome chrome_sandbox widevinecdmadapter
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P  $PKG_BUILD/out/Release/chrome $ADDON_BUILD/$PKG_ADDON_ID/bin/chromium.bin
  cp -P  $PKG_BUILD/out/Release/chrome_sandbox $ADDON_BUILD/$PKG_ADDON_ID/bin/chrome-sandbox
  cp -P  $PKG_BUILD/out/Release/{*.pak,*.dat,*.bin,libwidevinecdmadapter.so} $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -PR $PKG_BUILD/out/Release/locales $ADDON_BUILD/$PKG_ADDON_ID/bin/
  cp -PR $PKG_BUILD/out/Release/gen/content/content_resources.pak $ADDON_BUILD/$PKG_ADDON_ID/bin/

  # config *.dat,
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

  # unclutter
  cp -P $(get_build_dir unclutter)/.install_pkg/usr/bin/unclutter $ADDON_BUILD/$PKG_ADDON_ID/bin

  # xdotool
  cp -P $(get_build_dir xdotool)/xdotool $ADDON_BUILD/$PKG_ADDON_ID/bin
}
