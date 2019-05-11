# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="ffmpeg"
PKG_VERSION="3.1.11-Krypton-17.5"
PKG_VERSION="e38fc0a"
PKG_SHA256="e0edd3c83af64d28791668a0c00569e554ced334ceefeacd1af125d85b897207"
PKG_LICENSE="LGPLv2.1+"
PKG_SITE="https://github.com/FFmpeg/FFmpeg/tree/release/3.2"
PKG_URL="https://ffmpeg.org/releases/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_URL="https://github.com/FFmpeg/FFmpeg/archive/${PKG_VERSION}.tar.gz"
#PKG_URL="https://ffmpeg.org/releases/$PKG_NAME-$PKG_VERSION.tar.xz"
#PKG_URL="https://github.com/xbmc/FFmpeg/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain yasm:host zlib bzip2 openssl gnutls speex"
PKG_BUILD_FLAGS="-gold -lto"

# Dependencies
get_graphicdrivers

if [ "$VAAPI_SUPPORT" = "yes" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libva"
  FFMPEG_VAAPI="--enable-vaapi"
else
  FFMPEG_VAAPI="--disable-vaapi"
fi

if [ "$VDPAU_SUPPORT" = "yes" -a "$DISPLAYSERVER" = "x11" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET"
  FFMPEG_VDPAU="--enable-vdpau"
else
  FFMPEG_VDPAU="--disable-vdpau"
fi

if [ "$PROJECT" = "Rockchip" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET rkmpp"
  FFMPEG_RKMPP="--enable-rkmpp --enable-libdrm --enable-version3"
else
  FFMPEG_RKMPP="--disable-rkmpp"
fi

if build_with_debug; then
  FFMPEG_DEBUG="--enable-debug --disable-stripping"
else
  FFMPEG_DEBUG="--disable-debug --enable-stripping"
fi

if [ "$KODIPLAYER_DRIVER" = "bcm2835-driver" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET bcm2835-driver"
fi

case "$TARGET_ARCH" in
  arm)
    FFMPEG_TABLES="--enable-hardcoded-tables"
    ;;
  *)
    FFMPEG_TABLES="--disable-hardcoded-tables"
    ;;
esac

if target_has_feature neon; then
  FFMPEG_FPU="--enable-neon"
else
  FFMPEG_FPU="--disable-neon"
fi

if [ "$DISPLAYSERVER" = "x11" ]; then
  FFMPEG_X11GRAB="--enable-indev=x11grab_xcb"
fi

pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME

  export CFLAGS="$CFLAGS -Wno-attributes"
  export CXXFLAGS="$CXXFLAGS -Wno-attributes"

  if [ "$KODIPLAYER_DRIVER" = "bcm2835-driver" ]; then
    CFLAGS="-I$SYSROOT_PREFIX/usr/include/interface/vcos/pthreads -I$SYSROOT_PREFIX/usr/include/interface/vmcs_host/linux $CFLAGS"
    FFMPEG_LIBS="-lbcm_host -lvcos -lvchiq_arm -lmmal -lmmal_core -lmmal_util -lvcsm"
    FFMPEG_RPI="--enable-rpi"
  else
    FFMPEG_RPI="--disable-rpi"
  fi
}

configure_target() {
  ./configure --prefix="/usr" \
              --cpu="$TARGET_CPU" \
              --arch="$TARGET_ARCH" \
              --enable-cross-compile \
              --cross-prefix="$TARGET_PREFIX" \
              --sysroot="$SYSROOT_PREFIX" \
              --sysinclude="$SYSROOT_PREFIX/usr/include" \
              --target-os="linux" \
              --nm="$NM" \
              --ar="$AR" \
              --as="$CC" \
              --cc="$CC" \
              --ld="$CC" \
              --host-cc="$HOST_CC" \
              --host-cflags="$HOST_CFLAGS" \
              --host-ldflags="$HOST_LDFLAGS" \
              --host-libs="-lm" \
              --extra-cflags="$CFLAGS" \
              --extra-ldflags="$LDFLAGS -fPIC" \
              --extra-libs="$PKG_FFMPEG_LIBS" \
              --disable-static \
              --enable-shared \
              --enable-gpl \
              --disable-version3 \
              --enable-nonfree \
              --enable-logging \
              --disable-doc \
              $FFMPEG_DEBUG \
              --enable-pic \
              --pkg-config="$TOOLCHAIN/bin/pkg-config" \
              --enable-optimizations \
              --disable-extra-warnings \
              --disable-ffprobe \
              --disable-ffplay \
              --disable-ffserver \
              --enable-ffmpeg \
              --enable-avdevice \
              --enable-avcodec \
              --enable-avformat \
              --enable-swscale \
              --enable-postproc \
              --enable-avfilter \
              --disable-devices \
              --enable-pthreads \
              --disable-w32threads \
              --enable-network \
              --enable-gnutls --disable-openssl \
              --disable-gray \
              --enable-swscale-alpha \
              --disable-small \
              --enable-dct \
              --enable-fft \
              --enable-mdct \
              --enable-rdft \
              --disable-crystalhd \
              --enable-vaapi \
              --disable-vdpau \
              --disable-dxva2 \
              --enable-runtime-cpudetect \
              $FFMPEG_TABLES \
              --disable-memalign-hack \
              --disable-encoders \
              --enable-encoder=ac3 \
              --enable-encoder=aac \
              --enable-encoder=wmav2 \
              --enable-encoder=mjpeg \
              --enable-encoder=png \
              --disable-decoder=mpeg_xvmc \
              --enable-hwaccels \
              --enable-muxers \
              --enable-muxer=spdif \
              --enable-muxer=adts \
              --enable-muxer=asf \
              --enable-muxer=ipod \
              --enable-muxer=mpegts \
              --enable-demuxers \
              --enable-parsers \
              --enable-bsfs \
              --enable-protocol=http \
              --disable-indevs \
              --disable-outdevs \
              --enable-filters \
              --disable-avisynth \
              --enable-bzlib \
              --disable-frei0r \
              --disable-libopencore-amrnb \
              --disable-libopencore-amrwb \
              --disable-libopencv \
              --disable-libdc1394 \
              --disable-libfreetype \
              --disable-libgsm \
              --disable-libmp3lame \
              --disable-libnut \
              --disable-libopenjpeg \
              --disable-librtmp \
              --disable-libschroedinger \
              --enable-libspeex \
              --disable-libtheora \
              --disable-libvo-amrwbenc \
              --disable-libvorbis \
              --disable-libvpx \
              --disable-libx264 \
              --disable-libxavs \
              --disable-libxvid \
              --enable-zlib \
              --enable-asm \
              --disable-altivec \
              --disable-neon \
              --enable-yasm \
              --disable-symver \
              --disable-lto \
              --enable-indev=x11grab_xcb
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/share/ffmpeg/examples
}
