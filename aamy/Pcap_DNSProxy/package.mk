PKG_NAME="Pcap_DNSProxy"
PKG_VERSION="39ad239"
PKG_URL="https://github.com/chengr28/Pcap_DNSProxy/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl libpcap libsodium"
PKG_TOOLCHAIN="cmake-make"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DENABLE_LIBSODIUM=1 -DENABLE_PCAP=1 -DENABLE_TLS=1"
