FROM cloudgear/ruby:2.2

COPY nginx_signing.key /tmp/nginx_signing.key
RUN cat /tmp/nginx_signing.key | apt-key add -
RUN echo "deb http://nginx.org/packages/ubuntu/ trusty nginx" >> /etc/apt/sources.list.d/nginx.list

RUN apt-get update && apt-get install -y nginx && rm -rf /var/lib/apt/lists/*

# forward logs access and errors to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

RUN mkdir /var/log/unicorn
RUN ln -sf /dev/stderr /var/log/unicorn/output.log
RUN ln -sf /dev/stderr /var/log/unicorn/error.log

ADD nginx.conf /etc/nginx/nginx.conf
ADD unicorn.conf /etc/nginx/conf.d/nginx.conf
RUN rm -f /etc/nginx/conf.d/default.conf

EXPOSE 80



