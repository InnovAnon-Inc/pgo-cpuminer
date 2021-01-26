FROM innovanon/void-pgo as builder
ENV CC=
ENV CXX=
ENV FC=
ENV NM=
ENV AR=
ENV RANLIB=
ENV STRIP=
RUN sleep 91                                          \
 && git clone --depth=1 --recursive -b OpenSSL_1_1_1i \
      https://github.com/openssl/openssl.git          \
 && cd                           openssl              \
 && ./Configure --prefix=$PREFIX                      \
        --cross-compile-prefix=$CHOST-                \
	no-rmd160 no-sctp no-dso no-ssl2              \
	no-ssl3 no-comp no-idea no-dtls               \
	no-dtls1 no-err no-psk no-srp                 \
	no-ec2m no-weak-ssl-ciphers                   \
	no-afalgeng no-autoalginit                    \
	no-engine no-ec no-ecdsa no-ecdh              \
	no-deprecated no-capieng no-des               \
	no-bf no-dsa no-camellia no-cast              \
	no-gost no-md2 no-md4 no-rc2                  \
	no-rc4 no-rc5 no-whirlpool                    \
	no-autoerrinit no-blake2 no-chacha            \
	no-cmac no-cms no-crypto-mdebug               \
	no-ct no-crypto-mdebug-backtrace              \
	no-dgram no-dtls1-method                      \
	no-dynamic-engine no-egd                      \
	no-heartbeats no-hw no-hw-padlock             \
	no-mdc2 no-multiblock                         \
	no-nextprotoneg no-ocb no-ocsp                \
	no-poly1305 no-rdrand no-rfc3779              \
	no-scrypt no-seed no-srp no-srtp              \
	no-ssl3-method no-ssl-trace no-tls            \
	no-tls1 no-tls1-method no-ts no-ui            \
	no-unit-test no-whirlpool                     \
	no-posix-io no-async no-deprecated            \
	no-stdio no-egd                               \
        threads no-shared zlib                        \
	-static                                       \
        -DOPENSSL_SMALL_FOOTPRINT                     \
        -DOPENSSL_USE_IPV6=0                          \
        linux-x86_64                                  \
 && make -j$(nproc)                                   \
 && make install                                      \
 && git reset --hard                                  \
 && git clean -fdx                                    \
 && git clean -fdx                                    \
 && cd ..
ENV CC=$CHOST-gcc
ENV CXX=$CHOST-g++
ENV FC=$CHOST-gfortran
ENV NM=$CC-nm
ENV AR=$CC-ar
ENV RANLIB=$CC-ranlib
ENV STRIP=$CHOST-strip
RUN git clone --depth=1 --recursive -b curl-7_74_0    \
      https://github.com/curl/curl.git                \
 && cd                        curl                    \
 && autoreconf -fi                                    \
 && ./configure --prefix=$PREFIX                      \
        --target=$CHOST           \
        --host=$CHOST             \
	--with-zlib="$PREFIX"                         \
	--with-ssl="$PREFIX"                          \
        --disable-shared                              \
	--enable-static                               \
	--enable-optimize                             \
	--disable-curldebug                           \
	--disable-ares                                \
	--disable-rt                                  \
	--disable-ech                                 \
	--disable-largefile                           \
	--enable-http                                 \
	--disable-ftp                                 \
	--disable-file                                \
	--disable-ldap                                \
	--disable-ldaps                               \
	--disable-rtsp                                \
	--enable-proxy                                \
	--disable-dict                                \
	--disable-telnet                              \
	--disable-tftp                                \
	--disable-pop3                                \
	--disable-imap                                \
	--disable-smb                                 \
	--disable-smtp                                \
	--disable-gopher                              \
	--disable-mqtt                                \
	--disable-manual                              \
	--disable-libcurl-option                      \
	--disable-ipv6                                \
	--disable-sspi                                \
	--disable-crypto-auth                         \
	--disable-ntlm-wb                             \
	--disable-tls-srp                             \
	--disable-unix-sockets                        \
	--disable-cookies                             \
	--disable-socketpair                          \
	--disable-http-auth                           \
	--disable-doh                                 \
	--disable-mine                                \
	--disable-dataparse                           \
	--disable-netrc                               \
	--disable-progress-meter                      \
	--disable-alt-svc                             \
	--disable-hsts                                \
	--without-brotli                              \
	--without-zstd                                \
	--without-winssl                              \
	--without-schannel                            \
	--without-darwinssl                           \
	--without-secure-transport                    \
	--without-amissl                              \
	--without-gnutls                              \
	--without-mbedtls                             \
	--without-wolfssl                             \
	--without-mesalink                            \
	--without-bearssl                             \
	--without-nss                                 \
	--without-libpsl                              \
	--without-libmetalink                         \
	--without-librtmp                             \
	--without-winidn                              \
	--without-libidn2                             \
	--without-nghttp2                             \
	--without-ngtcp2                              \
	--without-nghttp3                             \
	--without-quiche                              \
	--disable-threaded-resolver                   \
	CPPFLAGS="$CPPFLAGS"                          \
	CXXFLAGS="$CXXFLAGS"                          \
	CFLAGS="$CFLAGS"                              \
	LDFLAGS="$LDFLAGS"                            \
        CPATH="$CPATH"                                \
        C_INCLUDE_PATH="$C_INCLUDE_PATH"              \
        OBJC_INCLUDE_PATH="$OBJC_INCLUDE_PATH"        \
        LIBRARY_PATH="$LIBRARY_PATH"                  \
        LD_LIBRARY_PATH="$LD_LIBRARY_PATH"            \
        LD_RUN_PATH="$LD_RUN_PATH"                    \
        PKG_CONFIG_LIBDIR="$PKG_CONFIG_LIBDIR"        \
        PKG_CONFIG_PATH="$PKG_CONFIG_PATH"            \
        CC="$CC"                                      \
        CXX="$CXX"                                    \
        FC="$FC"                                      \
        NM="$NM"                                      \
        AR="$AR"                                      \
        RANLIB="$RANLIB"                              \
        STRIP="$STRIP"                                \
 && make -j$(nproc)                                   \
 && make install                                      \
 && git reset --hard                                  \
 && git clean -fdx                                    \
 && git clean -fdx                                    \
 && cd ..                                             \
 && rm -v $PREFIX/bin/*curl*                          \
 \
 && ls -ltra /usr/local/lib | grep libcrypto.a \
 \
 && git clone --depth=1 --recursive                   \
      https://github.com/InnovAnon-Inc/cpuminer-yescrypt.git \
 && cd                                 cpuminer-yescrypt     \
 && ./autogen.sh                                             \
 && ./configure --prefix=$PREFIX                             \
        --target=$CHOST           \
        --host=$CHOST             \
	--disable-shared                                     \
	--enable-static                                      \
	--enable-assembly                                    \
        --with-curl=$PREFIX                                  \
        --with-crypto=$PREFIX                                \
	CPPFLAGS="$CPPFLAGS -DCURL_STATICLIB"                \
	CXXFLAGS="$CXXFLAGS"                                 \
	CFLAGS="$CFLAGS"                                     \
	LDFLAGS="$LDFLAGS"                                   \
        CPATH="$CPATH"                                \
        C_INCLUDE_PATH="$C_INCLUDE_PATH"              \
        OBJC_INCLUDE_PATH="$OBJC_INCLUDE_PATH"        \
        LIBRARY_PATH="$LIBRARY_PATH"                  \
        LD_LIBRARY_PATH="$LD_LIBRARY_PATH"            \
        LD_RUN_PATH="$LD_RUN_PATH"                    \
        PKG_CONFIG_LIBDIR="$PKG_CONFIG_LIBDIR"        \
        PKG_CONFIG_PATH="$PKG_CONFIG_PATH"            \
        CC="$CC"                                             \
        CXX="$CXX"                                           \
        FC="$FC"                                             \
        NM="$NM"                                             \
        AR="$AR"                                             \
        RANLIB="$RANLIB"                                     \
        STRIP="$STRIP"                                       \
 && cd $PREFIX                                               \
 && rm -rf etc man share ssl

#FROM scratch as squash
#COPY --from=builder / /
#RUN chown -R tor:tor /var/lib/tor
#SHELL ["/usr/bin/bash", "-l", "-c"]
#ARG TEST
#
#FROM squash as test
#ARG TEST
#RUN tor --verify-config \
# && sleep 127           \
# && xbps-install -S     \
# && exec true || exec false
#
#FROM squash as final
#
