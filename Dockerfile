# syntax = docker/dockerfile:1.3

FROM gentoo/portage:20211108 as portage
FROM gentoo/stage3:musl-20211108 as base

ENV FEATURES='nodoc noinfo noman -seccomp -ipc-sandbox -mount-sandbox -network-sandbox -pid-sandbox -sandbox -usersandbox' \
    VIDEO_CARDS='' \
    USE='static-libs bindist'

ADD binpkgs.tar /var/cache

COPY etc /etc/

RUN --mount=type=bind,target=/var/db/repos/gentoo,source=/var/db/repos/gentoo,from=portage \
    ls -l /var/cache/binpkgs && \
    emerge -qtbN --deep @world

