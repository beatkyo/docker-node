ARG IMAGE

FROM ${IMAGE}

RUN apk update && apk upgrade && apk add --no-cache --update ca-certificates curl && update-ca-certificates 

ARG NODE_VERSION

WORKDIR /root
RUN set -x \
 	&& apk add --no-cache libstdc++ \
	&& apk add --no-cache --virtual .build-deps \
   		binutils-gold \
        curl \
        g++ \
        gcc \
        gnupg \
        libgcc \
        linux-headers \
        make \
        python \
    # get node        
	&& curl -SL "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz" | tar -xJ \
	# make & install
	&& cd "node-v$NODE_VERSION" \
    && ./configure \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && make install \
    # clean
    && cd .. \
    && rm -Rf "node-v$NODE_VERSION" \
    # clean apk deps
    && apk del .build-deps

ARG YARN_VERSION

WORKDIR /opt/yarn
RUN apk add --no-cache --virtual .build-deps-yarn curl gnupg tar \
    && curl -SL "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" | tar -xz --strip-components=1 \
    # link binaries
    && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
    && ln -s /opt/yarn/bin/yarnpkg /usr/local/bin/yarnpkg \
    # clean apk deps
    && apk del .build-deps-yarn

WORKDIR /root

CMD [ "node" ]