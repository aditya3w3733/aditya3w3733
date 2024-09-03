FROM alpine:latest AS base

ENV HUGO_SITE=/srv/hugo

RUN apk --no-cache add \
    git \
    hugo \
    && mkdir -p ${HUGO_SITE} \
    && rm -rf /tmp/*

RUN git init

WORKDIR ${HUGO_SITE}
COPY .gitmodules ${HUGO_SITE}/.gitmodules
COPY .git ${HUGO_SITE}/.git
RUN git submodule update --init --recursive
COPY . ${HUGO_SITE}

RUN hugo --minify

FROM nginx:alpine
COPY --from=base /srv/hugo/public /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]
