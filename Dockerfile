FROM quay.io/trunk/ruby:2.2.1

ENV S6_VERSION v1.17.1.1

ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-amd64.tar.gz /tmp/s6-overlay.tar.gz

RUN tar xvfz /tmp/s6-overlay.tar.gz -C / \
    && rm -rf /tmp/*

COPY nginx_signing.key /tmp/
RUN cat /tmp/nginx_signing.key | apt-key add - && \
    echo "deb http://nginx.org/packages/ubuntu/ trusty nginx" >> /etc/apt/sources.list.d/nginx.list && \
    apt-get update && apt-get install --no-install-recommends -y nginx libpng12-0 libpq-dev libc-bin libpcre3 dpkg libcurl3-dev curl && \
    rm -rf /var/lib/apt/lists/* && \
    \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    \
    mkdir /var/log/unicorn && \
    ln -sf /dev/stderr /var/log/unicorn/output.log && \
    ln -sf /dev/stderr /var/log/unicorn/error.log && \
    \
    rm -f /etc/nginx/conf.d/default.conf

COPY rootfs /

EXPOSE 80

ENTRYPOINT ["/init"]


