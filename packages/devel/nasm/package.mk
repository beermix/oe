PKG_NAME="nasm"
PKG_VERSION="2.13.01"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain fontconfig"
PKG_DEPENDS_HOST=""
PKG_SECTION="lang"
PKG_SHORTDESC="nasm: A 80x86 assembler which can create a wide rande of object formats"
PKG_LONGDESC="The Netwide Assembler, NASM, is an 80x86 assembler designed for portability and modularity. It supports a range of object file formats, including Linux, Microsoft 16-bit OBJ and Win32. It will also output plain binary files. Its syntax is designed to be sim- ple and easy to understand, similar to Intel's but less complex. It supports Pentium, P6 and MMX opcodes, and has macro capability. It includes a disassembler as well."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"


post_make_target() {
  mkdir -p $INSTALL_DEV/usr/bin/
}