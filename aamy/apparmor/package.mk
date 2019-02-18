################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="apparmor"
PKG_VERSION="2.9.2"
PKG_SITE="http://apparmor.net"
PKG_URL="https://launchpad.net/apparmor/2.9/${PKG_VERSION}/+download/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_INIT="busybox:init linux:init"
PKG_DEPENDS_TARGET="apparmor:init"

PKG_SECTION="security"
PKG_SHORTDESC="Apparmor DAC"
PKG_LONGDESC="Linux application security framework - mandatory access control for programs"



pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
  strip_lto
  strip_gold
 }


configure_init() {
  echo "FIXING Makefile for $PKG_NAME"
  sed -i -e 's%^include common/Make.rules%include ../common/Make.rules%' parser/Makefile
}

configure_target() {
  :
}

make_init() {
  echo "Making $PKG_NAME"
  USE_SYSTEM=1
  HOST_YACC=$TOOLCHAIN/bin/bison
  HOST_LEX=$TOOLCHAIN/bin/flex
  (cd parser
    make YACC=$HOST_YACC LEX=$HOST_LEX BISON=$HOST_YACC CPP="$TARGET_CC -E -o - -" arch)
}

make_target() {
  :
}

makeinstall_init() {
  echo "Installing $PKG_NAME"

  local install_dir="$INSTALL"
  mkdir -p "$install_dir/etc/apparmor.d"
  (cd parser
    make DESTDIR="$install_dir" install-arch)
  if test -d $PKG_DIR/apparmor.d; then
    $PKG_DIR/tools/mkrules.sh $PKG_DIR/apparmor.d/rules.def <$PKG_DIR/apparmor.d/profile.tmpl >$install_dir/etc/apparmor.d/all.profile
    for f in $install_dir/etc/apparmor.d/*.profile; do
        sed -i -e 's/\s*flags=(complain)\s*/ /g' "$f"
    done
  fi
}

makeinstall_target() {
  :
}

post_install() {
  local install_dir="$BUILD/initramfs"
  if ! grep -q apparmor "$install_dir/init"; then
    echo "Patching $install_dir/init..."

    sed -i -e '/^\s*\/bin\/busybox\s\+mount\s\+-t\s\+sysfs\s\+sysfs/a\/bin\/busybox mount -t securityfs securityfs \/sys\/kernel\/security' "$install_dir/init"
    for line in \
      'BOOT_STEP=apparmor' \
      'progress "Apparmor"' \
      '/bin/sh -c "/sbin/apparmor_parser /etc/apparmor.d/all.profile" >/dev/apparmor.log 2>&1' \
      ; do
      local l=$(echo $line | sed 's%[/"=\$]%\\&%g')
      sed -i -e "/^\s*BOOT_STEP=final/i$l" "$install_dir/init"
    done

    if grep -q apparmor "$install_dir/init"; then
      echo "...done"
    fi
  fi
}
