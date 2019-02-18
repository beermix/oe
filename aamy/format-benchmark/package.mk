PKG_NAME="format-benchmark"
PKG_VERSION="9b179a1"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain readline"
PKG_SECTION="debug/tools"


unpack() {
  git clone --recursive -v --depth 1 git://github.com/fmtlib/format-benchmark $PKG_BUILD
  cd $PKG_BUILD
  git reset --hard $PKG_VERSION
  rm -rf .git
  cd $ROOT
}


make_target() {
  make
}