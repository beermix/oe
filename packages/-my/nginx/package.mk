PKG_NAME="nginx"
PKG_VERSION="1.12.0"
PKG_SITE="http://www.midnight-commander.org"
PKG_URL="http://nginx.org/download/nginx-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl"

PKG_SECTION="tools"


            

configure_target() {
cd $PKG_BUILD
CFLAGS="$optcflags" \
LDFLAGS="$optldflags" ./configure \
  --with-http_ssl_module \
  --prefix=/usr \
  --with-threads \
  --sbin-path=/usr/bin/nginx \
  --conf-path=/storage/.config/nginx/nginx.conf \
  --error-log-path=/storage/.config/nginx/error.log \
  --http-log-path=/storage/.config/nginx/access.log \
  --pid-path=/var/run/nginx.pid \
  --lock-path=/var/lock/nginx.lock \
  --with-http_dav_module \
  --http-client-body-temp-path=/storage/nginx/body \
  --http-fastcgi-temp-path=/storage/nginx/fastcgi \
  --http-proxy-temp-path=/storage/nginx/proxy \
  --http-scgi-temp-path=/storage/nginx/scgi \
  --http-uwsgi-temp-path=/storage/nginx/uwsgi
 }
  
make_target() {
make -j1
make install
}

post_makeinstall_target() {
  rm -rf $INSTALL/storage
}

post_install() {
  add_user nobody x 990 990 "nginx server" "/storage" "/bin/bash"
  add_group nobody 990
}

--prefix=/opt/nginx --with-cc-opt="-static -static-libgcc" \
            --with-ld-opt="-static" --with-cpu-opt=generic --with-pcre \
            --with-mail --with-ipv6 --with-poll_module --with-select_module \
            --with-rtsig_module --with-select_module --with-poll_module \
            --with-http_ssl_module --with-http_spdy_module --with-http_realip_module \
            --with-http_addition_module --with-http_sub_module --with-http_dav_module \
            --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module \
            --with-http_gzip_static_module --with-http_auth_request_module \
            --with-http_random_index_module --with-http_secure_link_module \
            --with-http_degradation_module --with-http_stub_status_module \
            --with-mail --with-mail_ssl_module --with-openssl=

