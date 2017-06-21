FROM cross-compiler:linux-x64

RUN mkdir -p /build
WORKDIR /build

#RUN apt-get upgrade -y 
#RUN apt-get dist-upgrade -y

#RUN apt-get install libssl-dev pkg-config -y

# Install Boost
ENV BOOST_VERSION 1.63.0
RUN curl -L https://dl.dropboxusercontent.com/s/9v8ytkus9j1qhpe/boost_1_63_0.tar.xz | tar xvJ && \
    cd boost_`echo ${BOOST_VERSION} | sed 's/\\./_/g'`/ && \
    ./bootstrap.sh --prefix=${CROSS_ROOT} && \
    ./b2 cflags="${CPPFLAGS} ${CFLAGS} -fPIC -O3" cxxflags="${CPPFLAGS} ${CXXFLAGS} -fPIC -O3" \
    --with-date_time --with-system --with-chrono --with-random cxxflags=-fPIC cflags=-fPIC \
    toolset=gcc link=static variant=release debug-symbols=off threading=multi target-os=linux install && \
    rm -rf ${HOME}/user-config.jam && \
    rm -rf `pwd`

# Install Golang
ENV BOOTSTRAP_GO_VERSION go1.4.3
ENV GO_VERSION go1.8.3
RUN cd /usr/local && \
    curl -L https://github.com/golang/go/archive/${BOOTSTRAP_GO_VERSION}.tar.gz | tar xvz && \
    cd /usr/local/go-${BOOTSTRAP_GO_VERSION}/src && \
    GOOS=linux GOARCH=amd64 CGO_ENABLED=0 ./make.bash
RUN cd /usr/local && \
    curl -L https://github.com/golang/go/archive/${GO_VERSION}.tar.gz | tar xvz
RUN cd /usr/local/go-${GO_VERSION}/src && \
	echo ${GO_VERSION} > /usr/local/go-${GO_VERSION}/VERSION && \
    GOROOT_BOOTSTRAP=/usr/local/go-${BOOTSTRAP_GO_VERSION} GOOS=linux GOARCH=amd64 CGO_ENABLED=1 ./make.bash
ENV PATH ${PATH}:/usr/local/go-${GO_VERSION}/bin

# Install OpenSSL
ENV OPENSSL_VERSION 1.1.0f
RUN curl -L http://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz | tar xvz && \
    cd openssl-${OPENSSL_VERSION}/ && \
    ./Configure no-shared threads no-sctp no-ssl-trace no-ssl3 no-weak-ssl-ciphers no-zlib no-zlib-dynamic enable-ec_nistp_64_gcc_128 linux-x86_64 --prefix=${CROSS_ROOT} && \
    make && make install_sw && \
    rm -rf `pwd`

# Install libtorrent
ENV LIBTORRENT_VERSION RC_1_1
RUN curl -L https://github.com/arvidn/libtorrent/archive/`echo ${LIBTORRENT_VERSION} | sed 's/\\./_/g'`.tar.gz | tar xz && \
    cd libtorrent-`echo ${LIBTORRENT_VERSION} | sed 's/\\./_/g'`/ && \
    ./autotool.sh && \
    \
    sed -i 's/$PKG_CONFIG openssl --libs-only-/$PKG_CONFIG openssl --static --libs-only-/' ./configure && \
    sed -i -e s/Windows.h/windows.h/ -e s/Wincrypt.h/wincrypt.h/ ./ed25519/src/seed.cpp && \
    \
    ./configure \
        --enable-static \
        --disable-shared \
        --disable-deprecated-functions \
        --disable-geoip \
        --disable-silent-rules \
        --disable-iconv \
        --host=${CROSS_TRIPLE} \
        --prefix=${CROSS_ROOT} \
        --with-boost=${CROSS_ROOT} \
        --with-boost-libdir=${CROSS_ROOT}/lib \
        CXXFLAGS="-march=ivybridge -m64 -O2 -pipe --param=l1-cache-size=32 --param=l1-cache-line-size=64 --param=l2-cache-size=6144 -mtune=ivybridge -mfpmath=sse" && \
    \
    make && make install && \
    rm -rf `pwd`
    

# Install SWIG
#ENV SWIG_VERSION 1079ba7
ENV SWIG_VERSION rel-3.0.12
RUN curl -L https://github.com/swig/swig/archive/${SWIG_VERSION}.tar.gz | tar xvz && \
    cd swig* && \
    ./autogen.sh && \
    ./configure --disable-shared && \
    make -j4 && make install && \
    rm -rf `pwd`


# Build
ENV GOPATH=/usr/.go
ENV GOOS=linux
ENV CGO_ENABLED=1
ENV CGO_NO_EMULATION=1
ENV CGO_CFLAGS=$CFLAGS

RUN go get -u -v -buildmode=exe -ldflags "-s -w" github.com/afedchin/torrent2http
#RUN go get -u -v -buildmode=exe -ldflags "-s -w" github.com/beermix/torrent2http
#RUN go get -u -v -buildmode=exe -ldflags "-s -w  -extldflags -static" github.com/dimitriss/torrent2http
#RUN go get -u -v -buildmode=exe -ldflags "-s -w" github.com/scakemyer/libtorrent-go
RUN ldd -v /usr/.go/bin/torrent2http
RUN mv /usr/.go/bin/torrent2http /usr/.go/bin/torrent2http-87697922

WORKDIR /
