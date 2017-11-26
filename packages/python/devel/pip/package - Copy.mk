PKG_NAME="setuptools"
PKG_VERSION=""
PKG_URL=""



pre_configure_host() {
  cd $PKG_BUILD
  curl https://bootstrap.pypa.io/ez_setup.py -o - | python
}

makeinstall_host() {
  :
}


make_host() {
  :
}
