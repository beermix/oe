PKG_NAME="oem"
PKG_VERSION=""
PKG_SITE="http://www.openelec.tv"
PKG_URL=""

if [ "$PROJECT" = "RPi" ]; then
PKG_DEPENDS_TARGET="gtk+ gdk-pixbuf alsa ffmpeg rutorrent cmake flex gettext libtool scons distutilscross simplejson setuptools idplay-libs chromium-browser initramfs lua zliben linux-drivers"
fi

if [ "$PROJECT" = "RPi2" ]; then
PKG_DEPENDS_TARGET=" dnscrypt-proxy libtorrent toolchain chromium-browser rtorrent toolchain setuptools libfontenc libICE libpciaccess libX11 libXau libxcb libXcomposite libXdamage libXext libXfixes libXfont libXrender libxshmfence libXt libXtst pixman xtrans libSM libstatgrab rlog atk libmtp libnfsidmap libpcap libsigc++ libXft libXcursor wxWidgets x11"
fi

if [ "$PROJECT" = "Generic" ]; then
#PKG_DEPENDS_TARGET="openjdk util-linux PyAMF arm-mem attr autoconf autoconf-archive bison boost ccache dbus-glib elfutils enca fakeroot fribidi glib glibc gmp intltool libcap libcec libdaemon libffi libftdi1 libirman libplist libpthread-stubs #lockdev m4 make mpc mpfr ncurses pcre readline swig yajl autoconf llvm sidplay-libs bzip2 lzo unzip  hadowsocks-libev shadowvpn fuse fuse-exfat libXi libXinerama libxkbfile libXmu libXrandr bitstream libmediainfo util-linux u-boot initramfs rtorrent util-linux u-boot lzo unzip zip zlib x264 shadowserver u-boot shadowvpn toolchain sqlite ethtool libshairplay bzip2 LVM2 pcsc-lite xdpyinfo xprop proftpd gdk-pixbuf harfbuzz acestream gtk+ obfs4proxy libXcursor libXft wxWidgets  libsigc++ whoisencfs binutils imlib2 xmlrpc-c Mopidy Pykka tornado openjdk p7zip pip libXrender libXft wxWidgets pyspotify intltool sthttpdmeek spotify-ripper mutagen tornado requests schedule setuptools libffi libspotify M2Crypto PyAMF acestream links acestream M2Crypto PyAMF gcc make automake docker openjdk binutils elfutils fdk-aac libtheora libvpx opus util-linux openjdk tor shadowvpn cffi mc openjdk lzo unzip flac taglib unrar zlib lzo unzip zip bzip2  acestream tor aria2 openjdk collective.recipe.distutils zc.buildout collective.recipe.distutils zc.buildout setuptools openvpn fdk-aac lame faac fdkaac aria2 openjdk xbmcswift2 lame sqlite wget aria2 acestream pathlib M2Crypto PyAMF cffi tor aria2 requests flac lame xz unrar zip pptp fdk-aac fdkaac tornado Pykka xam openvpn gtk+ privoxy LVM2 BeautifulSoup beautifulsoup4 xz unzip pvr.iptvsimple makeproxychains Libevent btrfs-progs git ncdu go lz4 fish jack2 zsh perl fish libXrender gtk+ LVM2 wine M2Crypto PyAMF M2Crypto PyAMF gtk+ btrfs-progs hid_mapper proxychains-ng  net-snmp fuse fuse-exfat zabbix iw fakeroot i2pd smartmontools x11-utils  btrfs-progs privoxy kodi-theme-Confluence pvr.iptvsimple acestream rsync perl pytube Files_Cloud_Backuper requests clint dirsnap xl2tpd speedtest-cli bind dnscrypt-proxy libffi gtk+ wxWidgets daemonize alsa-plugins mc net-snmp strace pyspotify libsamplerate lm_sensors alsa-plugins x11vnc aufs-util coreutils ipset libnetfilter_queue zsh bash libtorrent-rasterbar dnscrypt-proxy fio mc ncdu tig x11vnc strace make Linux-PAM unbound net-snmp LVM2 dnscrypt-proxy nonroot psmisc libvncserver sshfs shadowsocks-libev aircrack-ng davfs2 xcalib gmp ncurses hiawatha libnfnetlink libnetfilter_queue libnetfilter_conntrack ipset alsa-plugins smartmontools aircrack-ng proftpd libtorrent-rasterbar transmission intel-gpu-tools coreutils xcalib tor libtorrent-rasterbar lzip lrzip libpthread gtk+ wine libnetfilter_conntrack libnetfilter_queue libnfnetlink vdpauinfo xcalib perl mono dash alsa-plugins pure-ftpd xcalib intel-gpu-tools libtorrent-rasterbar x11vnc aircrack-ng libtorrent-rasterbar xcalib PySocks intel-gpu-tools dropbear putty megatools grep openssl libcap attr libunwind libevent libdaemon dbus coreutils procps-ng psmisc bash intel-gpu-tools xcalib strace libtorrent-rasterbar diffutils patch sshfs git lm_sensors aircrack-ng smartmontools davfs2 intel-gpu-tools megatools dropbear libtorrent-rasterbar xcalib alsa-plugins libxkbcommon libiconv aufs-util intel-gpu-tools xcalib intel-gpu-tools LVM2 putty bashhub-clientbitcoin gnupg intel-gpu-tools openvpn libtorrent-rasterbar madplay lzip xcalib xfsprogs SDL2_mixer ncdu psmisc bzip2 wget tar findutils grep gawk xz file inetutils bash lm-sensors aircrack-ng sshfs smartmontools x11vnc megatools aircrack-ng libtorrent-rasterbar madplay SDL2_mixer dropbear x11vnc intel-gpu-tools madplay strace faac dropbear putty perl intel-gpu-tools libtorrent-rasterbar megatools aircrack-ng bitcoin megatools aircrack-ng strace faac dropbear putty bitcoin lm_sensors lzip davfs2 libtorrent-rasterbar which megatools davfs2 libaio testdisk ModemManager bwm-ng strace diffutils dnsmasq privoxy libtorrent-rasterbar iftop wireless_tools ModemManager megatools daemonize nftables vlc dnscrypt-proxy libtorrent-rasterbar perl reaver reaver-wps-fork-t6x x11vnc nmap megatools wget aircrack-ng nmap megatools wget bridge-utils ps3remote zapret dnsmasq gawk psmisc xcalib PySocks tor tigervnc aircrack-ng reaver-wps-fork-t6x perl wine zabbix intel-gpu-tools LVM2 megatools BeautifulSoup wxWidgets intel-gpu-tools flickcurl qemu beautifulsoup4 bwm-ng intel-gpu-tools xf86-video-intel tar aufs-util LVM2 aufs-util macchanger lzip lrzip bridge-utils smartmontools aufs-util vlc nmap strace davfs2 gevent psutil aircrack-ng pixiewps reaver-wps-fork-t6x fio bonnie bwm-ng daemonize vlc nmap strace davfs2 gevent psutil aircrack-ng pixiewps reaver-wps-fork-t6x fio bwm-ng daemonize libtorrent-rasterbar vlc daemonize nmap psutil aircrack-ng pixiewps reaver-wps-fork-t6x fio bonnie bwm-ng daemonize vlc bonnie vlc wget xfsprogs daemonize gevent xf86-video-intel gevent xcalib vlc intel-gpu-tools strace bridge-utils xf86-video-intel davfs2 vlc mrxvt dolphin dosbox-sdl2 fs-uae retroarch vlc libtorrent-rasterbar fio libtorrent-rasterbar vlc intel-gpu-tools reaver-wps-fork-t6x bully vlc intel-gpu-tools gdb perl lua zfs netdata pure-ftpd shadowsocks-libev time coreutils psmisc psutil less xf86-video-intel tor iperf lm_sensors f2fs-tools bwm-ng davfs2 daemonize ncdu bridge-utils sshfs gevent M2Crypto PyAMF pyxattr polipo macchanger strace nmap xfsprogs aircrack-ng reaver-wps-fork-t6x pixiewps perl gevent xf86-video-intel git polipo PySocks PyAMF M2Crypto gevent pyxattr netdata pure-ftpd shadowsocks-libev time coreutils psmisc psutil less tor iperf lm_sensors f2fs-tools fio bwm-ng davfs2 daemonize ncdu bridge-utils sshfs macchanger nmap xfsprogs aircrack-ng reaver-wps-fork-t6x pixiewps bridge-utils inetutils bzip2 aufs-util fio vlc shadowsocks-libev intel-gpu-tools nmap aircrack-ng reaver-wps-fork-t6x pixiewps macchanger nmap fio davfs2 mrxvt strace netdata bwm-ng vlc powertop mrxvt speedtest unrar aircrack-ng reaver-wps-fork-t6x pixiewps bully strace megatools bonnie macchanger nmap fio davfs2 netdata lm_sensors bwm-ng nmap fio megatools bonnie vlc perl patool tor bully netdata vlc nmap megatools aircrack-ng reaver-wps-fork-t6x pixiewps bully vlc gperftools intel-gpu-tools vlc inetutils tor strace macchanger davfs2 vlc gperftools intel-gpu-tools tor strace macchanger davfs2 usb-modeswitch perl intel-gpu-tools inetutils psmisc tor gperftools netdata bwm-ng nmap davfs2 aircrack-ng reaver-wps-fork-t6x pixiewps gevent speedtest inetutils psmisc strace intel-gpu-tools bwm-ng minicom intel-gpu-tools speedtest xf86-video-intel tor perl vlc netdata macchanger nmap aircrack-ng reaver-wps-fork-t6x pixiewps dolphin vlc x11vnc vlc Mako dolphin perl nmap vlc reaver-wps-fork-t6x pixiewps aircrack-ng intel-gpu-tools inetutils gevent gdb davfs2 polipo strace bwm-ng nonroot testdisk perl nano vlc intel-gpu-tools fio aircrack-ng pixiewps nmap inetutils Mako vlc gevent gdb davfs2 polipo strace bwm-ng mesa-demos nonroot netdata perl gdb intel-gpu-tools nmap netdata vlc gevent davfs2 inetutils strace polipo aircrack-ng reaver-wps-fork-t6x pixiewps vlc strace gevent speedtest x11vnc ps3remote alsa-plugins xcalib wget intel-gpu-tools mesa-demos acephproxy gdb mesa-demos intel-gpu-tools speedtest nmap aircrack-ng reaver-wps-fork-t6x pixiewps vlc mesa-demos speedtest gperf gdb alsa-plugins xcalib psmisc intel-gpu-tools strace xupnpd scan-m3u psutil gevent bwm-ng netdata vlc speedtest gperf gdb alsa-plugins mesa-demos strace xupnpd scan-m3u psutil gevent davfs2 reaver-wps-fork-t6x PyAMF davfs2 netdata vlc PyAMF M2Crypto ps3remote alsa-plugins mesa-demos intel-gpu-tools xfsprogs daemonize bwm-ng xupnpd scan-m3u psutil gevent PySocks xf86-video-intel gevent vlc strace intel-gpu-tools kodi-theme-AeonNox gdb vlc netdata gperf alsa-plugins vlc gdb nmap gevent xupnpd scan-m3u psutil alsa-plugins lua daemonize reaver-wps-fork-t6x pixiewps netdata davfs2 pyxattr sshfs idna six evdev cffi boost intel-gpu-tools gdb intel-gpu-tools gevent boost intel-gpu-tools netdata pyxattr reaver-wps-fork-t6x davfs2 strace lz4 gdb strace vlc netdata remote gdb vlc libtorrent-rasterbar BeautifulSoup beautifulsoup4 intel-gpu-tools mesa-demos vlc nmap libtorrent-rasterbar gevent xupnpd scan-m3u psutil intel-gpu-tools gdb strace netdata davfs2 reaver-wps-fork-t6x alsa-plugins Mako daemonize intel-gpu-tools reaver-wps-fork-t6x sed libtorrent-rasterbar strace netdata irqbalance pyxattr bwm-ng acestream x11vnc pstate-frequency reaver-wps-fork-t6x xupnpd scan-m3u psutil nmap vlc alsa-plugins davfs2 netdata daemonize reaver-wps-fork-t6x PySocks irqbalance iproute2 xf86-video-intel vlc davfs2 reaver-wps-fork-t6x perl gevent xupnpd scan-m3u psutil tor xupnpd scan-m3u psutil gevent vlc alsa-plugins perl strace davfs2 xupnpd scan-m3u psutil gevent xcalib perl gevent xupnpd scan-m3u psutil requests vlc davfs2 reaver-wps-fork-t6x Mako xupnpd scan-m3u psutil strace netdata xf86-video-intel mesa-demos gdb vlc gconf reaver-wps-fork-t6x davfs2 strace vlc nmap netdata mesa-demos gtk2 bwm-ng libtorrent-rasterbar BeautifulSoup beautifulsoup4 PySocks vlc nmap netdata mesa-demos alsa-plugins noxbit acephproxy gevent aceproxy xupnpd scan-m3u lua gconf vlc netdata mesa-demos acephproxy gevent aceproxy xupnpd scan-m3u lua reaver-wps-fork-t6x noxbit acephproxy gevent aceproxy xupnpd scan-m3u lua reaver-wps-fork-t6x noxbit vlc gtk3 Python3 mesa-demos gdb netdata libvdpau gdb strace irqbalance smartmontools gdb dash x11vnc irqbalance daemonize sshfs pyxattr acestream gdb strace netdata libvdpau irqbalance nano xz smartmontools strace netdata gdb strace netdata libvdpau irqbalance PySocks strace netdata irqbalance gdb smartmontools irqbalance netdata smartmontools gtk+ libXt Python3 vlc lua reaver-wps-fork-t6x perl davfs2 gtk+ freshplayerplugin perl Python3 davfs2 nmap xf86-video-intel xz acestream pyxattr xfsprogs x11vnc strace bwm-ng gtk+ libxss cups strace irqbalance acestream strace perl perl gtk3 x11vnc nmap strace davfs2 sysdig gtk3 wine:host wine gtk3 libXt cups freshplayerplugin x11vnc mesa-demos strace libxss xinput intel-gpu-tools chrome"  

# py=urllib3 chardet psutil bencode typing certifi idna
PKG_DEPENDS_TARGET="gdb daemonize file nano zsh git ncdu sshfs pyxattr pure-ftpd acestream lm_sensors"

#PKG_DEPENDS_TARGET="zsh tor x11vnc squid rsyslog intel-gpu-tools flickcurl"
#pciutils dbus libXcomposite libXcursor libXtst alsa-lib bzip2 libXScrnSaver libexif harfbuzz atk gtk+ libevent

# flickcurl pciutils dbus libXcomposite libXcursor libXtst alsa-lib libXScrnSaver libexif harfbuzz atk gtk+
fi

PKG_SECTION="virtual"
PKG_SHORTDESC="OEM: Metapackage for various OEM packages"
PKG_LONGDESC="OEM: Metapackage for various OEM packages"



