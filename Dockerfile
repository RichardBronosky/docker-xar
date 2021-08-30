# syntax=docker/dockerfile:1
FROM alpine:latest AS builder
RUN apk --no-cache add git build-base autoconf libxml++-2.6-dev libressl-dev fts-dev musl-dev
RUN git clone https://github.com/mackyle/xar
    
RUN cd xar/xar && export LDFLAGS="-lfts" && ./autogen.sh && \
    ./configure --enable-static=yes --enable-shared=no
RUN cd xar/xar && export LDFLAGS="-all-static" && make && \
    make install --just-print > make_install_script

FROM alpine:latest
COPY --from=builder /xar/xar /tmp/xar
RUN apk add libbz2 libressl libxml2 fts
RUN cd /tmp/xar && source make_install_script && cd / && rm -rf /tmp/xar
