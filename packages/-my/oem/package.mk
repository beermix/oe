PKG_NAME="oem"
PKG_VERSION=""
PKG_SITE="http://www.openelec.tv"
PKG_URL=""

if [ "$PROJECT" = "RPi" ]; then
PKG_DEPENDS_TARGET="gtk+ gdk-pixbuf alsa ffmpeg rutorrent cmake flex gettext libtool scons swig distutilscross simplejson setuptools idplay-libs chromium-browser initramfs lua zliben linux-drivers"
fi

if [ "$PROJECT" = "RPi2" ]; then
PKG_DEPENDS_TARGET=" dnscrypt-proxy libtorrent toolchain chromium-browser rtorrent toolchain setuptools libfontenc libICE libpciaccess libX11 libXau libxcb libXcomposite libXdamage libXext libXfixes libXfont libXrender libxshmfence libXt libXtst pixman xtrans libSM libstatgrab rlog atk libmtp libnfsidmap libpcap libsigc++ libXft libXcursor wxWidgets x11"
fi

if [ "$PROJECT" = "Generic" ]; then
#PKG_DEPENDS_TARGET="openjdk util-linux PyAMF arm-mem attr autoconf autoconf-archive automake binutils bison boost ccache dbus-glib elfutils enca fakeroot fribidi glib glibc gmp intltool libcap libcec libdaemon libffi libftdi1 libirman libplist libpthread-stubs #lockdev m4 make mpc mpfr ncurses pcre readline swig yajl autoconf llvm gcc yasm sidplay-libs bzip2 lzo unzip  zip zlib #sqlite shadowsocks-libev shadowvpn fuse fuse-exfat libXi libXinerama libxkbfile libXmu libXrandr bitstream #libmediainfo  util-linux u-boot initramfs rtorrent util-linux u-boot lzo unzip zip zlib x264 shadowserver u-boot #shadowvpn toolchain sqlite ethtool libshairplay bzip2 LVM2 pcsc-lite xdpyinfo xprop proftpd gdk-pixbuf harfbuzz acestream gtk+  obfs4proxy libXcursor libXft wxWidgets  libsigc++ whoisencfs binutils imlib2 xmlrpc-c Mopidy Pykka tornado openjdk p7zip pip libXrender libXft wxWidgets pyspotify intltool   sthttpdmeek spotify-ripper mutagen tornado requests schedule setuptools libffi libspotify M2Crypto PyAMF acestream links acestream M2Crypto PyAMF gcc make automake docker openjdk binutils elfutils fdk-aac libtheora libvpx opus util-linux openjdk tor shadowvpn cffi mc openjdk lzo unzip flac taglib unrar zlib lzo unzip zip bzip2  acestream tor aria2 openjdk collective.recipe.distutils zc.buildout collective.recipe.distutils zc.buildout setuptools openvpn fdk-aac lame faac fdkaac aria2 openjdk xbmcswift2 lame sqlite wget aria2 acestream pathlib M2Crypto PyAMF cffi tor aria2 requests flac lame xz unrar zip pptp fdk-aac fdkaac tornado Pykka xam openvpn gtk+ privoxy LVM2 BeautifulSoup beautifulsoup4 xz unzip pvr.iptvsimple makeproxychains Libevent btrfs-progs git ncdu go lz4 fish jack2 zsh perl fish libXrender gtk+ LVM2 wine M2Crypto PyAMF M2Crypto PyAMF gtk+ btrfs-progs hid_mapper proxychains-ng  net-snmp fuse fuse-exfat zabbix iw fakeroot i2pd smartmontools x11-utils  btrfs-progs privoxy kodi-theme-Confluence pvr.iptvsimple acestream rsync perl pytube Files_Cloud_Backuper requests clint dirsnap xl2tpd speedtest-cli bind dnscrypt-proxy libffi gtk+ wxWidgets daemonize alsa-plugins mc net-snmp strace pyspotify libsamplerate lm_sensors alsa-plugins x11vnc aufs-util coreutils ipset libnetfilter_queue zsh bash libtorrent-rasterbar dnscrypt-proxy fio mc ncdu tig x11vnc strace make Linux-PAM unbound net-snmp LVM2 dnscrypt-proxy nonroot psmisc libvncserver sshfs shadowsocks-libev aircrack-ng davfs2 xcalib gmp ncurses hiawatha libnfnetlink libnetfilter_queue libnetfilter_conntrack ipset alsa-plugins smartmontools aircrack-ng proftpd libtorrent-rasterbar transmission intel-gpu-tools coreutils xcalib tor libtorrent-rasterbar lzip lrzip libpthread gtk+ wine libnetfilter_conntrack libnetfilter_queue libnfnetlink vdpauinfo xcalib perl mono dash alsa-plugins pure-ftpd xcalib intel-gpu-tools libtorrent-rasterbar x11vnc aircrack-ng libtorrent-rasterbar xcalib PySocks intel-gpu-tools dropbear putty megatools grep openssl libcap attr libunwind libevent libdaemon dbus coreutils procps-ng psmisc bash intel-gpu-tools xcalib strace libtorrent-rasterbar diffutils patch sshfs git lm_sensors aircrack-ng smartmontools davfs2 intel-gpu-tools megatools dropbear  libtorrent-rasterbar xcalib alsa-plugins libxkbcommon libiconv aufs-util intel-gpu-tools xcalib intel-gpu-tools LVM2 putty bashhub-clientbitcoin gnupg intel-gpu-tools openvpn libtorrent-rasterbar madplay lzip xcalib xfsprogs SDL2_mixer ncdu psmisc bzip2 wget tar findutils grep gawk xz file inetutils bash lm-sensors aircrack-ng sshfs smartmontools x11vnc megatools aircrack-ng libtorrent-rasterbar madplay SDL2_mixer dropbear x11vnc intel-gpu-tools madplay strace faac dropbear putty perl intel-gpu-tools libtorrent-rasterbar megatools aircrack-ng bitcoin megatools aircrack-ng strace faac dropbear putty bitcoin lm_sensors lzip davfs2 libtorrent-rasterbar which megatools davfs2 libaio testdisk ModemManager bwm-ng strace diffutils dnsmasq privoxy libtorrent-rasterbar iftop wireless_tools ModemManager megatools daemonize nftables vlc dnscrypt-proxy libtorrent-rasterbar perl reaver reaver-wps-fork-t6x x11vnc nmap megatools wget aircrack-ng nmap megatools wget bridge-utils ps3remote zapret dnsmasq gawk psmisc xcalib PySocks tor tigervnc aircrack-ng reaver-wps-fork-t6x perl wine zabbix intel-gpu-tools LVM2 megatools BeautifulSoup wxWidgets intel-gpu-tools flickcurl qemu beautifulsoup4 bwm-ng intel-gpu-tools xf86-video-intel tar aufs-util LVM2 aufs-util macchanger lzip lrzip bridge-utils smartmontools aufs-util vlc nmap strace davfs2 gevent psutil aircrack-ng pixiewps reaver-wps-fork-t6x fio bonnie bwm-ng daemonize vlc nmap strace davfs2 gevent psutil aircrack-ng pixiewps reaver-wps-fork-t6x fio bwm-ng daemonize libtorrent-rasterbar vlc daemonize nmap psutil aircrack-ng pixiewps reaver-wps-fork-t6x fio bonnie bwm-ng daemonize vlc bonnie vlc wget xfsprogs daemonize gevent xf86-video-intel gevent xcalib vlc intel-gpu-tools strace bridge-utils xf86-video-intel davfs2 vlc mrxvt dolphin dosbox-sdl2 fs-uae retroarch vlc libtorrent-rasterbar fio libtorrent-rasterbar vlc intel-gpu-tools reaver-wps-fork-t6x bully  vlc intel-gpu-tools gdb perl lua zfs netdata pure-ftpd shadowsocks-libev time coreutils psmisc psutil less xf86-video-intel tor iperf lm_sensors f2fs-tools bwm-ng davfs2 daemonize ncdu bridge-utils sshfs gevent M2Crypto PyAMF pyxattr polipo macchanger strace nmap xfsprogs aircrack-ng reaver-wps-fork-t6x pixiewps perl gevent xf86-video-intel git polipo PySocks PyAMF M2Crypto gevent pyxattr netdata pure-ftpd shadowsocks-libev time coreutils psmisc psutil less tor iperf lm_sensors f2fs-tools fio bwm-ng davfs2 daemonize ncdu bridge-utils sshfs macchanger nmap xfsprogs aircrack-ng reaver-wps-fork-t6x pixiewps bridge-utils inetutils bzip2 aufs-util fio vlc shadowsocks-libev intel-gpu-tools aircrack-ng reaver-wps-fork-t6x pixiewps macchanger squid strace nmap vlc"
 
#PKG_DEPENDS_TARGET="isualization.shadertoy inputstream.adaptive inputstream.mpd inputstream.rtmp inputstream.smoothstream"

PKG_DEPENDS_TARGET="xf86-video-intel ps3remote xcalib speedtest bash gawk xz grep findutils unrar file nano zsh git polipo PySocks gevent PyAMF M2Crypto pyxattr netdata pure-ftpd time coreutils psmisc psutil less tor iperf lm_sensors f2fs-tools bwm-ng davfs2 daemonize ncdu sshfs fio xfsprogs"

#PKG_DEPENDS_TARGET="zsh tor x11vnc squid rsyslog intel-gpu-tools"
#pciutils dbus libXcomposite libXcursor libXtst alsa-lib bzip2 yasm nss libXScrnSaver libexif harfbuzz atk gtk+ libevent

# flickcurl pciutils dbus libXcomposite libXcursor libXtst alsa-lib libXScrnSaver libexif harfbuzz atk gtk+
fi


PKG_SECTION="virtual"
PKG_SHORTDESC="OEM: Metapackage for various OEM packages"
PKG_LONGDESC="OEM: Metapackage for various OEM packages"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"
