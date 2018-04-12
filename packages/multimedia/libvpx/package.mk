################################################################################

PKG_NAME="libvpx"
PKG_VERSION="768b018"
#PKG_SHA256="1fec931eb5c94279ad219a5b6e0202358e94a93a90cfb1603578c326abfc1238"
PKG_ARCH="any"
PKG_LICENSE="BSD"
PKG_SITE="https://github.com/webmproject/libvpx/releases"
PKG_URL="https://github.com/webmproject/libvpx/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain yasm:host"
PKG_SECTION="multimedia"
PKG_SHORTDESC="WebM VP8/VP9 Codec SDK"
PKG_LONGDESC="The WebM Project is dedicated to developing a high-quality, open video format for the web that's freely available to everyone."
PKG_BUILD_FLAGS="-lto -gold -hardening"

configure_target() {

# CFLAGS=`echo $CFLAGS | sed -e "s|-D_FORTIFY_SOURCE=2||"`
# CPPFLAGS=`echo $CPPFLAGS | sed -e "s|-D_FORTIFY_SOURCE=2||"`

  $PKG_CONFIGURE_SCRIPT --prefix="/usr" \
                        --target="x86_64-linux-gcc" \
                        --cpu="$TARGET_CPU" \
                        --as=yasm \
                        --enable-pic \
                        --enable-vp8 \
                        --enable-vp9 \
                        --enable-postproc \
                        --enable-vp9-postproc \
                        --enable-vp9-temporal-denoising \
                        --enable-libyuv \
                        --disable-encode-perf-tests \
                        --disable-decode-perf-tests \
                        --disable-examples \
                        --disable-debug-libs \
                        --disable-docs \
                        --disable-install-docs \
                        --enable-runtime-cpu-detect \
                        --disable-shared \
                        --disable-install-srcs \
                        --enable-vp9-highbitdepth \
                        --enable-experimental \
                        --enable-spatial-svc \
                        --disable-unit-tests
}
