# syntax = docker/dockerfile:1.3
FROM gentoo/stage3:nomultilib-20211104

ENV FEATURES='nodoc noinfo noman -ipc-sandbox -network-sandbox -pid-sandbox'
ENV USE='static-libs'

RUN --mount=type=cache,target=/var/cache/binpkgs \
    emerge-webrsync \
    emerge -bk app-portage/flaggie app-portage/gentoolkit app-portage/eix && \
    eix-update && \
    flaggie --strict --destructive-cleanup dev-lisp/sbcl +~amd64 && \
    flaggie --strict --destructive-cleanup dev-lisp/asdf +~amd64 && \
    flaggie --strict --destructive-cleanup dev-lisp/uiop +~amd64 && \
    flaggie --strict --destructive-cleanup dev-vcs/git -perl && \
    flaggie --strict --destructive-cleanup media-gfx/imagemagick:0/6.9.11-60 -openmp -cxx -bzip2 -zlib && \
    flaggie --strict --destructive-cleanup media-libs/sdl2-image +png && \
    emerge -bk media-libs/libsdl2 media-gfx/imagemagick:0/6.9.11-60 media-libs/sdl2-image dev-lisp/sbcl dev-vcs/git

