PKG_NAME="expat"
PKG_VERSION="2.2.4"
PKG_URL="http://sources.lede-project.org/expat-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="textproc"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

pre_make_host() {
  # fix builderror when building in subdirs
  cp -r ../doc .
}

pre_make_target() {
  # fix builderror when building in subdirs
  cp -r ../doc .
}
