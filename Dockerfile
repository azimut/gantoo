# syntax = docker/dockerfile:1.3

FROM gentoo/portage:20200905 as portage
FROM gentoo/stage3:nomultilib-20200905 as base

ENV FEATURES='nodoc noinfo noman -seccomp -ipc-sandbox -mount-sandbox -network-sandbox -pid-sandbox -sandbox -usersandbox' \
    USE='bindist'

ADD binpkgs.tar /var/cache

COPY etc /etc/

RUN --mount=type=bind,target=/var/db/repos/gentoo,source=/var/db/repos/gentoo,from=portage \
    emerge -qtbk app-eselect/eselect-repository dev-vcs/git && \
    mkdir /etc/portage/repos.conf && \
    eselect repository add azimut git https://github.com/azimut/overlay.git && \
    emaint sync -r azimut

RUN --mount=type=bind,target=/var/db/repos/gentoo,source=/var/db/repos/gentoo,from=portage \
    ls -l /var/cache/binpkgs /etc/portage && \
    emerge -qtbk app-portage/flaggie app-portage/gentoolkit app-portage/eix app-eselect/eselect-repository dev-vcs/git && \
    emerge -qtbk media-libs/libsdl2 media-gfx/imagemagick media-libs/sdl2-image dev-lisp/sbcl && \
    eix-update
