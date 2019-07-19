# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="ffmpeg"
#PKG_VERSION="3.1.11-Krypton-17.5"
#PKG_SHA256=""
PKG_VERSION="ba11e40"
PKG_SHA256="a42832ed347b0460813b5a4a2ee31bfb7082bd57c27234c77330eae37353a242"
PKG_LICENSE="LGPLv2.1+"
PKG_SITE="https://github.com/FFmpeg/FFmpeg/tree/release/3.2"
PKG_URL="https://ffmpeg.org/releases/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_URL="https://github.com/FFmpeg/FFmpeg/archive/${PKG_VERSION}.tar.gz"
#PKG_URL="https://ffmpeg.org/releases/$PKG_NAME-$PKG_VERSION.tar.xz"
#PKG_URL="https://github.com/xbmc/FFmpeg/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib bzip2 gnutls speex"
PKG_LONGDESC="FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video."
PKG_BUILD_FLAGS="-gold"

# Dependencies
get_graphicdrivers

if [ "$V4L2_SUPPORT" = "yes" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libdrm"
  PKG_FFMPEG_V4L2="--enable-libdrm"
else
  PKG_FFMPEG_V4L2=""
fi

if [ "$VAAPI_SUPPORT" = "yes" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libva"
  PKG_FFMPEG_VAAPI="--enable-vaapi"
else
  PKG_FFMPEG_VAAPI="--disable-vaapi"
fi

if [ "$VDPAU_SUPPORT" = "yes" -a "$DISPLAYSERVER" = "x11" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libvdpau"
  PKG_FFMPEG_VDPAU="--enable-vdpau"
else
  PKG_FFMPEG_VDPAU="--disable-vdpau"
fi

if [ "$PROJECT" = "Rockchip" ]; then
  PKG_PATCH_DIRS+=" rkmpp"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET rkmpp"
  PKG_FFMPEG_RKMPP="--enable-libdrm --enable-version3"
else
  PKG_FFMPEG_RKMPP=""
fi

if [ "$PROJECT" = "Allwinner" ]; then
  PKG_PATCH_DIRS+=" v4l2-request-api"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libdrm systemd" # systemd is needed for libudev
  PKG_FFMPEG_V4L2_REQUEST="--enable-v4l2-request --enable-libudev --enable-libdrm"
fi

if build_with_debug; then
  PKG_FFMPEG_DEBUG="--enable-debug --disable-stripping"
else
  PKG_FFMPEG_DEBUG="--disable-debug --enable-stripping"
fi

if [ "$KODIPLAYER_DRIVER" = "bcm2835-driver" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET bcm2835-driver"
  PKG_PATCH_DIRS+=" rpi-hevc"
fi

if target_has_feature neon; then
  PKG_FFMPEG_FPU="--enable-neon"
else
  PKG_FFMPEG_FPU="--disable-neon"
fi

if [ "$TARGET_ARCH" = "x86_64" ]; then
  PKG_DEPENDS_TARGET+=" nasm:host"
fi

if target_has_feature "(neon|sse)"; then
  PKG_DEPENDS_TARGET+=" dav1d"
  PKG_FFMPEG_AV1="--enable-libdav1d"
fi

pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME

  if [ "$KODIPLAYER_DRIVER" = "bcm2835-driver" ]; then
    PKG_FFMPEG_LIBS="-lbcm_host -lvcos -lvchiq_arm -lmmal -lmmal_core -lmmal_util -lvcsm"
    PKG_FFMPEG_RPI="--enable-rpi"
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
              --extra-cflags="$CFLAGS -Wno-attributes -Wno-deprecated-declarations" \
              --extra-ldflags="$LDFLAGS" \
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
              --enable-ffprobe \
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
              $PKG_FFMPEG_V4L2 \
              $PKG_FFMPEG_VAAPI \
              $PKG_FFMPEG_VDPAU \
              $PKG_FFMPEG_RPI \
              $PKG_FFMPEG_RKMPP \
              $PKG_FFMPEG_V4L2_REQUEST \
              --enable-runtime-cpudetect \
              --disable-memalign-hack \
              --disable-hardcoded-tables \
              --enable-encoders \
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
              $PKG_FFMPEG_FPU \
              --disable-symver \
              --enable-indev=x11grab_xcb
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/share/ffmpeg/examples
}
