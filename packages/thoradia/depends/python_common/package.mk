PKG_NAME="python_common"
PKG_VERSION="1"
PKG_DEPENDS_TARGET="libxslt:host cffi libxslt"
PKG_LONGDESC="Common Python dependencies"

PKG_TOOLCHAIN="python2"

pre_make_target() {
  export LDSHARED="-pthread"

  cat << EOF > setup.py
#!/usr/bin/env python

from setuptools import setup

setup(name='$PKG_NAME',
      version='$PKG_VERSION',
      description='$PKG_LONGDESC',
      author='thoradia',
      url='https://github.com/thoradia/LibreELEC.tv',
      install_requires=[
          "asn1crypto==0.24.0",
          "cryptography==2.1.4",
          "enum34==1.1.6",
          "idna==2.6",
          "ipaddress==1.0.19",
          "lxml==4.1.1",
          "pyOpenSSL==17.5.0",
          "setuptools==38.5.1",
          "six==1.11.0",
        ],
     )
EOF
}

post_make_target() {
  _site="usr/lib/$PKG_PYTHON_VERSION/site-packages"
  cp -r "$(get_build_dir cffi)/.install_pkg/$_site"/*.egg "$INSTALL/$_site"
  cat "$(get_build_dir cffi)/.install_pkg/$_site/easy-install.pth" >> "$INSTALL/$_site/easy-install.pth"
}
