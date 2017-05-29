FROM debian:jessie-backports

MAINTAINER Marcelo Almeida <marcelo.almeida@jumia.com>

WORKDIR "/root"

ENV DEBIAN_FRONTEND noninteractive
ENV VERSION 0.4.3

# INSTALL BUILDER DEPENDENCIES
RUN apt-get update && apt-get install -y --no-install-recommends \
  apt-utils \
  autoconf \
  automake \
  build-essential \
  checkinstall \
  git-core \
  libtool \
  make \
  pkg-config

COPY src /src

# CREATE PACKAGE
RUN git clone git://github.com/jbboehr/libmustache.git --recursive ;\
  cd libmustache ;\
  git checkout v$VERSION ;\
  cp -r /src/* /root/libmustache/. ;\
  autoreconf -fiv ;\
  ./configure --prefix=/usr ;\
  checkinstall --install=no --pkgname='libmustache4' --pkgversion='$VERSION' --pkggroup='libs' --pkgsource='https://github.com/jbboehr/libmustache' --maintainer='Marcelo Almeida \<marcelo.almeida@jumia.com\>' --requires='libc6 \(\>= 2.19\), libgcc1 \(\>= 1:4.9.2\), libjson-c2 \(\>= 0.11\), libstdc++6 \(\>= 4.9.2\), libyaml-0-2 \(\>= 0.1.6\)' --strip=no --stripso=no --addso=yes

VOLUME ["/pkg"]
