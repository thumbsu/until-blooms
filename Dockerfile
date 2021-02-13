FROM mhart/alpine-node:15.5 AS builder
WORKDIR /app
COPY package.json .
COPY package-lock.json .
COPY yarn.lock .
RUN npm i
COPY . .
RUN npm run build

##########

FROM alpine:3.12.3 AS nginx

WORKDIR /

# Install Entrykit
RUN apk add openssl wget tar \
  && rm -rf /var/cache/apk/* \
  && wget https://github.com/progrium/entrykit/releases/download/v0.4.0/entrykit_0.4.0_Linux_x86_64.tgz

# entrykit unzip
RUN tar -xzvf entrykit_0.4.0_Linux_x86_64.tgz \
  && rm entrykit_0.4.0_Linux_x86_64.tgz \
  && mv entrykit /bin/entrykit \
  && chmod +x /bin/entrykit \
  && entrykit --symlink

RUN apk add nginx
RUN mkdir -p /run/nginx
RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /app/public /usr/share/nginx/html
COPY ./contrib/docker/nginx.conf.tmpl /etc/nginx/nginx.conf.tmpl

ENTRYPOINT [ \
  "switch", \
    "shell=/bin/sh", \
    "version=nginx -v", "--", \
  "render", \
    "/etc/nginx/nginx.conf", \
    "--", \
    "/usr/sbin/nginx" \
]