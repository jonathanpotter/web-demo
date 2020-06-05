# Get website content with builder container.
FROM docker.io/centos:centos7.6.1810 AS builder

ARG WEBSITE_CONTENT=https://github.com/jonathanpotter/jonathanpotter.github.io/archive/master.zip
ARG PACKAGES="wget unzip"

RUN yum install -y ${PACKAGES} && \
    wget -O master.zip ${WEBSITE_CONTENT} && \
    unzip master.zip

# Use an official nginx parent image from Red RedHat
# See https://access.redhat.com/containers/#/registry.access.redhat.com/rhel8/nginx-116
# And https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-docker/
FROM docker.io/nginx:latest

ENV PORT=8080

COPY --from=builder jonathanpotter.github.io-master/ .

EXPOSE $PORT

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
