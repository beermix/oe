PKG_NAME="pyparsing"
PKG_VERSION="2.4.2"
PKG_LICENSE="OSS"
PKG_SITE="https://pypi.python.org/pypi/pyparsing"
PKG_URL="https://pypi.python.org/packages/3c/ec/a94f8cf7274ea60b5413df054f82a8980523efd712ec55a59e7c3357cf7c/pyparsing-2.2.0.tar.gz"
PKG_DEPENDS_HOST="Python2:host"
PKG_PRIORITY="optional"
PKG_SECTION="python/devel"
PKG_SHORTDESC="packaging: a Python Parsing Module"
PKG_LONGDESC="The pyparsing module is an alternative approach to creating and executing simple grammars, vs. the traditional lex/yacc approach, or the use of regular expressions. The pyparsing module provides a library of classes that client code uses to construct the grammar directly in Python code."
PKG_TOOLCHAIN="manual"

makeinstall_host() {
  mkdir -p $TOOLCHAIN/lib/python2.7/site-packages
    cp -R pyparsing.py $TOOLCHAIN/lib/python2.7/site-packages
}
