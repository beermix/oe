PKG_NAME="libav"
PKG_VERSION="12.1"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
#PKG_GIT_URL="https://github.com/libav/libav"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

 get_graphicdrivers

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
  strip_lto
  strip_gold
}

configure_target() {
  ./configure --prefix=/usr \
              --cpu=$TARGET_CPU \
              --arch=$TARGET_ARCH \
              --enable-cross-compile \
              --cross-prefix=${TARGET_NAME}- \
              --sysroot=$SYSROOT_PREFIX \
              --sysinclude="$SYSROOT_PREFIX/usr/include" \
              --target-os="linux" \
              --extra-version="$PKG_VERSION" \
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
              --extra-libs="$FFMPEG_LIBS" \
              --extra-version="" \
              --build-suffix="" \
              --enable-static \
              --disable-shared \
              --enable-gpl \
              --disable-version3 \
              --enable-nonfree \
              --enable-logging \
              --disable-doc \
              $FFMPEG_DEBUG \
              --enable-pic \
              --pkg-config="$ROOT/$TOOLCHAIN/bin/pkg-config" \
              --enable-optimizations \
              --disable-extra-warnings \
              --enable-avdevice \
              --enable-avcodec \
              --enable-avformat \
              --enable-swscale \
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
              --disable-dxva2 \
              --enable-runtime-cpudetect \
              --disable-memalign-hack \
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
              --disable-libopenjpeg \
              --disable-librtmp \
              --disable-libschroedinger \
              --enable-libspeex \
              --disable-libtheora \
              --disable-libvo-amrwbenc \
              --disable-libvorbis \
              --disable-libvpx \
              --disable-libx265 \
              --disable-libx264 \
              --disable-libxavs \
              --disable-libxvid \
              --enable-zlib \
              --enable-asm \
              --disable-altivec \
              --enable-yasm \
              --disable-symver \
              --disable-lto \
              --disable-libfdk-aac \
              --enable-indev=x11grab_xcb
}