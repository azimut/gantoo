# syntax = docker/dockerfile:1.3

FROM gentoo/portage:20211104 as portage
FROM gentoo/stage3:nomultilib-20211104 as base

ENV FEATURES='nodoc noinfo noman -ipc-sandbox -mount-sandbox -network-sandbox -pid-sandbox -sandbox -usersandbox'
ENV USE='static-libs'

COPY . /

RUN --mount=type=bind,target=/var/db/repos/gentoo,source=/var/db/repos/gentoo,from=portage \
    --mount=type=cache,id=distfiles,target=/var/cache/distfiles \
    --mount=type=cache,id=base-binpkgs,target=/var/cache/binpkgs \
    emerge -bk app-portage/flaggie app-portage/gentoolkit app-portage/eix && \
    emerge -bk media-libs/libsdl2 media-gfx/imagemagick:0/6.9.11-60 media-libs/sdl2-image dev-lisp/sbcl dev-vcs/git && \
    eix-update
