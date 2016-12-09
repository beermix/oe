PKG_NAME="musl"
PKG_VERSION="1.1.14"
PKG_URL="https://dl.dropboxusercontent.com/s/7s506a9a5cv1cby/musl-1.1.14.tar.gz"
PKG_DEPENDS_TARGET="autotools:host autoconf:host linux:host gcc:bootstrap"
PKG_DEPENDS_HOST="musl"

PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


pre_configure_host() {
  strip_gold
  export CFLAGS="$(filter-out -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64,$(TARGET_CFLAGS)) $(MUSL_EXTRA_CFLAGS)"
  export CPPFLAGS="$(filter-out -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64,$(TARGET_CPPFLAGS))"s
}

#PKG_CONFIGURE_OPTS_TARGET="--sort-section=none"