FROM cloudgear/ruby:2.2

COPY nginx_signing.key /tmp/nginx_signing.key

RUN cat /tmp/nginx_signing.key | apt-key add - && \
    echo "deb http://nginx.org/packages/ubuntu/ trusty nginx" >> /etc/apt/sources.list.d/nginx.list && \
    apt-get update && apt-get install -y nginx && \
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

ADD nginx.conf /etc/nginx/nginx.conf
ADD unicorn.conf /etc/nginx/conf.d/nginx.conf

EXPOSE 80



