
PKG_NAME="onionphone"
PKG_VERSION="0.1"
PKG_SITE="http://torfone.org/onionphone/"
PKG_DEPENDS_TARGET="toolchain tor alsa-lib"

PKG_SECTION="security"
PKG_SHORTDESC="OnionPhone"
PKG_LONGDESC="OnionPhone is a VOIP tool for calling over Tor network."




download() {
  local PACKAGE="$PKG_NAME-$PKG_VERSION"
  if (test ! -d "$SOURCES/$PKG_NAME") || (test ! -f $SOURCES/$PKG_NAME/$PACKAGE.tar.gz); then
    rm -rf $SOURCES/$PKG_NAME/tmp
    rm -f $SOURCES/$PKG_NAME/$PACKAGE.tar.gz
    rm -f $SOURCES/$PKG_NAME/$PACKAGE.tar.gz.md5
    rm -f $SOURCES/$PKG_NAME/$PACKAGE.tar.gz.url
    mkdir -p $SOURCES/$PKG_NAME/tmp
    (cd $SOURCES/$PKG_NAME/tmp
    git clone https://github.com/gegel/onionphone
    mv onionphone $PACKAGE
    tar czf ../$PACKAGE.tar.gz $PACKAGE)
    echo $PKG_SITE >$SOURCES/$PKG_NAME/$PACKAGE.tar.gz.url
    (cd $SOURCES/$PKG_NAME; md5sum -t $PACKAGE.tar.gz >$PACKAGE.tar.gz.md5)
  fi
}

unpack() {
  local PACKAGE="$PKG_NAME-$PKG_VERSION"
  if (test ! -d "$PKG_BUILD") || (test ! -f "$PKG_BUILD/.openelec-unpack"); then
    (cd "$BUILD"
    rm -rf $PACKAGE
    tar xzf $SOURCES/$PKG_NAME/$PACKAGE.tar.gz
    cd $PKG_BUILD
    rm -rf ".openelec-unpack"
    for i in PKG_NAME PKG_VERSION PKG_REV PKG_SHORTDESC PKG_LONGDESC PKG_SITE PKG_URL PKG_SECTION; do
      eval val=\$$i
      echo "STAMP_$i=\"$val"\" >>".openelec-unpack"
    done)
  fi
}

pre_configure_target() {
  download
  unpack
}

configure_target() {
 : # do nothing
}

make_target() {
  cd $PKG_BUILD
  make 
  ${TARGET_STRIP} oph
  ${TARGET_STRIP} addkey 
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  cp $PKG_BUILD/oph $INSTALL/usr/bin
  cp $PKG_BUILD/addkey $INSTALL/usr/bin
}

