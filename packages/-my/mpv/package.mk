PKG_NAME="mpv"
PKG_VERSION="v0.24.0"
PKG_SITE="http://qt-project.org"
PKG_GIT_URL="https://github.com/mpv-player/mpv"
PKG_DEPENDS="bcm2835-driver bzip2 Python zlib:host zlib libpng tiff dbus glib fontconfigeglibc liberation-fonts-ttf font-util font-xfree86-type1 font-misc-misc gstreamer gst-plugins-base gst-plugins-good gst-omx gst-plugins-bad alsa"
PKG_BUILD_DEPENDS_TARGET="bcm2835-driver bzip2 Python zlib:host zlib libpng tiff dbus glib fontconfig mysql openssl linux-headers eglibc gstreamer gst-plugins-base gst-plugins-good gst-omx gst-plugins-bad alsa"
PKG_SECTION="lib"
PKG_SHORTDESC="MPlayer; video player"
PKG_LONGDESC="MPlayer; video player"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC -DPIC"
  strip_lto
}

PKG_CONFIGURE_OPTS="\
	--prefix=/usr \
	--enable-runtime-cpudetection \
	--enable-cross-compile
"


configure_target() {
	CPPFLAGS_SAVE=${CPPFLAGS}
	CFLAGS_SAVE=${CFLAGS}
	LDFLAGS_SAVE=${LDFLAGS}
	YASMFLAGS_SAVE=${YASMFLAGS}

	unset CPPFLAGS
	unset CFLAGS
	unset LDFLAGS
	unset YASMFLAGS

	pushd ${ROOT}/${BUILD}/${PKG_NAME}-${PKG_VERSION}
	./configure ${PKG_CONFIGURE_OPTS}
	popd

	CPPFLAGS=${CPPFLAGS_SAVE}
	CFLAGS=${CFLAGS_SAVE}
	LDFLAGS=${LDFLAGS_SAVE}
	YASMFLAGS=${YASMFLAGS_SAVE}
}

make_target() {
	pushd $ROOT/$BUILD/${PKG_NAME}-${PKG_VERSION}
	make
	popd
}

makeinstall_target() {
	pushd ${ROOT}/${PKG_BUILD}
	mkdir .install_pkg || true
	DESTDIR=.install_pkg/ make install
	popd
}



export DEB_BUILD_MAINT_OPTIONS:=hardening=+all

# To enable parallel building:
# You can either set DEB_BUILD_OPTIONS=paralell=<num-procs> in your build environment
# or provide the -j<numprocs> option to debuild or dpkg-buildpackage, which
# ammounts to the same thing.
ifneq (,$(filter parallel=%,$(DEB_BUILD_OPTIONS)))
	NUMJOBS = $(patsubst parallel=%,%,$(filter parallel=%,$(DEB_BUILD_OPTIONS)))
# use MFLAGS, rather than MAKEFLAGS as the latter is used by make internally
	MFLAGS += -j$(NUMJOBS)
	WAFFLAGS += -j$(NUMJOBS)
endif

# make .PHONY all the targets that have name collisions with the scripts
# see http://www.debian.org/doc/manuals/maint-guide/dreq.en.html#rules
.PHONY: clean build install
# Apparently, the above isn't enough because of the "%" target. Make the problematic targets explicit
clean:
	exec dh $@
build:
	exec dh $@
install:
	exec dh $@
# Handle all other targets in the usual way.
# The --parallel flag to dh doesn't seem to have the intended effect
# so leave it out.
%:
	exec dh $@

libass_config:
	scripts/libass-config

libass_build: libass_config
	scripts/libass-build $(MFLAGS)

# depend on libass_build in case the user specified --enable-libass in ffmpeg_options
ffmpeg_config: libass_build
	scripts/ffmpeg-config \
		--enable-gnutls \
		--enable-libgme \
		--enable-libgsm \
		--enable-libmodplug \
		--enable-libmp3lame \
		--enable-netcdf \
		--enable-libopus \
		--enable-libpulse \
		--enable-libsoxr \
		--enable-libspeex \
		--enable-libssh \
		--enable-libtheora \
		--enable-libtwolame \
		--enable-libvorbis \
		--enable-libvpx \
		--enable-libwavpack \
		--enable-ladspa \
		--enable-libbs2b \
		--enable-gpl --enable-libxvid --enable-libx264 \
		--enable-version3 --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libvo-amrwbenc

ffmpeg_build: ffmpeg_config
	scripts/ffmpeg-build $(MFLAGS)

# put the config in the right place and drop the local/ since it's package managed now
override_dh_auto_configure: ffmpeg_build libass_build
	scripts/mpv-config --prefix=/usr --confdir=/etc/mpv --enable-openal

override_dh_auto_build:
	scripts/mpv-build $(WAFLAGS)


DOCSOURCE=mpv/DOCS
TOOLSSOURCE=mpv/TOOLS
DOCDEST=debian/mpv/usr/share/doc/mpv
TOOLSDEST=$(DOCDEST)/TOOLS
# call waf to install to the debian packageing dir
override_dh_auto_install:
	cd mpv && python waf -v install --destdir=../debian/mpv

	find "$(DOCSOURCE)" -mindepth 1 -type d \
	-not -regex '.*man.*' \
	-not -regex '.*client_api_examples.*' \
	-printf "%P\0" | \
	xargs -0i /usr/bin/install -d "$(DOCDEST)/{}"

	find "$(DOCSOURCE)" -mindepth 1 -type f \
	-not -regex '.*man.*' \
	-not -regex '.*client_api_examples.*' \
	-not -name 'tech-overview.txt' \
	-not -name 'waf-buildsystem.rst' \
	-not -name 'crosscompile-mingw.md' \
	-not -name 'coding-style.md' \
	-printf "%P\0" | \
	xargs -0i /usr/bin/install -m644 "$(DOCSOURCE)/{}" "$(DOCDEST)/{}"

	find "$(TOOLSSOURCE)" -mindepth 1 -type d \
	-not -regex '.*osxbundle.*' \
	-printf "%P\0" | \
	xargs -0i /usr/bin/install -d "$(TOOLSDEST)/{}"

	find "$(TOOLSSOURCE)" -mindepth 1 -type f \
	-not -regex '.*osxbundle.*' \
	-not -name 'gen-x11-icon.sh' \
	-not -name 'file2string.pl' \
	-not -name 'uncrustify.cfg' \
	-printf "%P\0" | \
	xargs -0i /usr/bin/install -m644 "$(TOOLSSOURCE)/{}" "$(TOOLSDEST)/{}"

# for manually installed dependencies
override_dh_shlibdeps:
	dh_shlibdeps --dpkg-shlibdeps-params=--ignore-missing-info

# call all the cleans
override_dh_auto_clean:
./clean
