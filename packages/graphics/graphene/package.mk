PKG_NAME="graphene"
PKG_VERSION="1.5.4"
PKG_GIT_URL="https://github.com/ebassi/graphene"
PKG_PRIORITY="optional"
PKG_SECTION="graphics"


pre_configure_target() {
  #sed -i '1s/python$/&2/' $PKG_BUILD/build/identfilter.py
  NOCONFIGURE=1 ./autogen.sh
}
PKG_CONFIGURE_OPTS_HOST="--disable-shared --enable-static --enable-gtk-doc"
