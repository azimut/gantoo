# syntax = docker/dockerfile:1.3

FROM gentoo/portage:20211104 as portage
FROM gentoo/stage3:nomultilib-20211104 as base

ENV FEATURES='nodoc noinfo noman -ipc-sandbox -mount-sandbox -network-sandbox -pid-sandbox -sandbox -usersandbox' \
    USE='static-libs'

ADD binpkgs.tar /var/cache

COPY . /

RUN --mount=type=bind,target=/var/db/repos/gentoo,source=/var/db/repos/gentoo,from=portage \
    ls -l /var/cache/binpkgs /etc/portage && \
    emerge -qtbk app-portage/flaggie app-portage/gentoolkit app-portage/eix app-eselect/eselect-repository dev-vcs/git && \
    mkdir /etc/portage/repos.conf && \
    eselect repository add azimut git https://github.com/azimut/overlay.git && \
    emaint sync -r azimut && \
    emerge -qtbk media-libs/libsdl2 media-gfx/imagemagick:0/6.9.11-60 media-libs/sdl2-image dev-lisp/sbcl::azimut && \
    eix-update
