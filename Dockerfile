FROM cross-compiler:linux-x64

RUN mkdir -p /build
WORKDIR /build

# update system
ENV update system
RUN apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade && apt-get install -y mc git automake libpcre3-dev bison yodl autoconf-archive cmake

# Install Boost.System
ENV BOOST_VERSION 1.62.0
RUN curl -L http://sourceforge.net/projects/boost/files/boost/${BOOST_VERSION}/boost_`echo ${BOOST_VERSION} | sed 's/\\./_/g'`.tar.bz2/download | tar xvj && \
    cd boost_`echo ${BOOST_VERSION} | sed 's/\\./_/g'`/ && \
    ./bootstrap.sh --prefix=${CROSS_ROOT} && \
    echo "using gcc : linux : ${CROSS_TRIPLE}-c++ ;" > ${HOME}/user-config.jam && \
    ./b2 --with-date_time --with-system --with-chrono --with-random --prefix=${CROSS_ROOT} toolset=gcc-linux debug-symbols=off link=static variant=release threading=multi target-os=linux install && \
    rm -rf ${HOME}/user-config.jam && \
    rm -rf `pwd`

# Install OpenSSL
ENV OPENSSL_VERSION 1.1.0c
RUN curl -L http://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz | tar xvz && \
    cd openssl-${OPENSSL_VERSION}/ && \
    CROSS_COMPILE=${CROSS_TRIPLE}- ./Configure threads no-shared enable-ec_nistp_64_gcc_128 linux-x86_64 --prefix=${CROSS_ROOT} && \
    make && make install_sw && \
    rm -rf `pwd`

# Install Golang
ENV BOOTSTRAP_GO_VERSION go1.4.3
ENV GO_VERSION go1.7.4
RUN cd /usr/local && \
    curl -L https://github.com/golang/go/archive/${BOOTSTRAP_GO_VERSION}.tar.gz | tar xvz && \
    cd /usr/local/go-${BOOTSTRAP_GO_VERSION}/src && \
    CC_FOR_TARGET=${CROSS_TRIPLE}-cc CXX_FOR_TARGET=${CROSS_TRIPLE}-c++ GOOS=linux GOARCH=amd64 CGO_ENABLED=0 ./make.bash
RUN cd /usr/local && \
    curl -L https://github.com/golang/go/archive/${GO_VERSION}.tar.gz | tar xvz
RUN cd /usr/local/go-${GO_VERSION}/src && \
	echo ${GO_VERSION} > /usr/local/go-${GO_VERSION}/VERSION && \
    GOROOT_BOOTSTRAP=/usr/local/go-${BOOTSTRAP_GO_VERSION} CC_FOR_TARGET=${CROSS_TRIPLE}-cc CXX_FOR_TARGET=${CROSS_TRIPLE}-c++ GOOS=linux GOARCH=amd64 CGO_ENABLED=1 ./make.bash
ENV PATH ${PATH}:/usr/local/go-${GO_VERSION}/bin
# Install SWIG
ENV SWIG_VERSION 3.0.10
RUN curl -L https://github.com/swig/swig/archive/rel-${SWIG_VERSION}.tar.gz | tar xvz && \
    cd swig-rel-${SWIG_VERSION}/ && \
    ./autogen.sh && \
    ./configure --enable-static --disable-shared LDFLAGS="-s -Wl,--as-needed" && make && make install && \
    rm -rf `pwd`

# Install libtorrent
ENV LIBTORRENT_VERSION 1.0.10
RUN curl -L https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_0_10/libtorrent-rasterbar-1.0.10.tar.gz | tar xvz && \
    cd libtorrent-* && \
    sed -i 's/$PKG_CONFIG openssl --libs-only-/$PKG_CONFIG openssl --static --libs-only-/' ./configure && \
    sed -i -e s/Windows.h/windows.h/ -e s/Wincrypt.h/wincrypt.h/ ./ed25519/src/seed.cpp && \
    \
    PKG_CONFIG_PATH=${CROSS_ROOT}/lib/pkgconfig/ \
    CC=${CROSS_TRIPLE}-gcc CXX=${CROSS_TRIPLE}-g++ \
    CFLAGS="${CFLAGS} -Ofast" \
    CXXFLAGS="${CXXFLAGS} ${CFLAGS} -std=gnu++98" \
    CPPFLAGS="-D_FORTIFY_SOURCE=2" \
    ./configure --enable-static --disable-shared --disable-geoip --enable-silent-rules \
    --host=${CROSS_TRIPLE} --prefix=${CROSS_ROOT} \
    --with-boost=${CROSS_ROOT} --with-boost-libdir=${CROSS_ROOT}/lib && \
    \
    make && make install && \
    rm -rf `pwd`

ENV GOPATH=/usr/.go
ENV GOOS=linux
ENV CGO_ENABLED=1
ENV CGO_NO_EMULATION=1
ENV CGO_CFLAGS=$CFLAGS

RUN go get -u -v -buildmode=exe -ldflags "-s -w" github.com/beermix/torrent2http
#RUN go get -u -v -buildmode=exe -ldflags "-s -w" github.com/dimitriss/torrent2http
#RUN go get -u -v -buildmode=exe -ldflags "-s -w" github.com/scakemyer/torrent2http
RUN ldd -v /usr/.go/bin/torrent2http
RUN mv /usr/.go/bin/torrent2http /usr/.go/bin/torrent2http366

WORKDIR /
