# syntax = docker/dockerfile:1.3

FROM gentoo/portage:20211104 as portage
FROM gentoo/stage3:nomultilib-20211104 as base

ENV FEATURES='nodoc noinfo noman -ipc-sandbox -mount-sandbox -network-sandbox -pid-sandbox -sandbox -usersandbox'
ENV USE='static-libs'

COPY etc/portage/package.use/flaggie     /etc/portage/package.use/flaggie
COPY etc/portage/package.accept_keywords /etc/portage/package.accept_keywords

RUN --mount=type=bind,target=/var/db/repos/gentoo,source=/var/db/repos/gentoo,from=portage \
    --mount=type=cache,id=distfiles,target=/var/cache/distfiles \
    --mount=type=cache,id=base-binpkgs,target=/var/cache/binpkgs \
    ls -l /var/cache/binpkgs && \
    emerge -bk app-portage/flaggie app-portage/gentoolkit app-portage/eix && \
    ls -l /var/cache/binpkgs && \
    eix-update
