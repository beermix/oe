PKG_NAME="waf"
PKG_VERSION="waf-1.9.9"
PKG_GIT_URL="https://github.com/waf-project/waf"
PKG_DEPENDS_HOST="toolchain Python2:host boost"
PKG_SECTION="tools"


configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
  
  ./waf-light configure
  
  ./waf-light build	
   
  #point waf binary to waflib dir and strip payload
        sed -e "/INSTALL=/s:=.*:='$TOOLCHAIN/bin':" \
                -e "/REVISION=/s:=.*:='1.9.9':" \
                -e "s:/lib/:/$(get_libdir)/:" \
                -e "/^#\(==>\|BZ\|<==\)/d" \
                -i waf || die
        dobin waf

        insinto /usr/$(get_libdir)/${PN}3-${PV}-${PR}
        doins -r waflib
}