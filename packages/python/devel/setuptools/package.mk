PKG_NAME="setuptools"
PKG_VERSION="0"
PKG_URL=""
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_host() {
  cd $ROOT/$PKG_BUILD
  curl https://bootstrap.pypa.io/ez_setup.py -o - | python
}

makeinstall_host() {
  :
}


make_host() {
  :
}
