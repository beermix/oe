################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="ffmpeg"
PKG_VERSION="0a34092"
PKG_ARCH="any"
PKG_LICENSE="LGPLv2.1+"
PKG_SITE="https://github.com/FFmpeg/FFmpeg/branches/active"
#PKG_URL="https://github.com/xbmc/FFmpeg/archive/${PKG_VERSION}.tar.gz"
PKG_URL="https://github.com/FFmpeg/FFmpeg/archive/${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="FFmpeg-${PKG_VERSION}*"
PKG_DEPENDS_TARGET="toolchain yasm:host zlib bzip2 openssl speex"
PKG_SECTION="multimedia"
PKG_SHORTDESC="FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video."
PKG_LONGDESC="FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video."
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
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libvdpau"
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

pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME

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
              --extra-ldflags="$LDFLAGS" \
              --extra-libs="$FFMPEG_LIBS" \
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
              --disable-gnutls --enable-openssl \
              --disable-gray \
              --enable-swscale-alpha \
              --disable-small \
              --enable-dct \
              --enable-fft \
              --enable-mdct \
              --enable-rdft \
              --disable-crystalhd \
              $FFMPEG_VAAPI \
              $FFMPEG_VDPAU \
              --disable-dxva2 \
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
              --disable-muxers \
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
              $FFMPEG_FPU \
              --disable-runtime-cpudetect \
              --disable-symver \
              --disable-amd3dnow \
              --disable-amd3dnowext \
              --enable-mmx \
              --enable-mmxext \
              --enable-sse \
              --enable-sse2 \
              --enable-sse3 \
              --enable-ssse3 \
              --enable-sse4 \
              --enable-sse42 \
              --disable-avx \
              --disable-xop \
              --disable-fma3 \
              --disable-fma4 \
              --disable-avx2 \
              --disable-aesni \
              --disable-armv5te \
              --disable-armv6 \
              --disable-armv6t2 \
              --disable-vfp \
              --disable-neon \
              --enable-inline-asm \
              --enable-yasm
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/share/ffmpeg/examples
}
