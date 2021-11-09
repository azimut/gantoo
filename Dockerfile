# syntax = docker/dockerfile:1.3

FROM gentoo/portage:20211108 as portage
FROM gentoo/stage3:musl-20211108 as base

ENV FEATURES='nodoc noinfo noman -seccomp -ipc-sandbox -mount-sandbox -network-sandbox -pid-sandbox -sandbox -usersandbox' \
    USE='static-libs bindist' \
    VIDEO_CARDS=''

ADD binpkgs.tar /var/cache

COPY etc /etc/

RUN --mount=type=bind,target=/var/db/repos/gentoo,source=/var/db/repos/gentoo,from=portage \
    ls -l /var/cache /var/cache/binpkgs && \
    emerge -qtbk app-eselect/eselect-repository && \
    ls -l /var/cache /var/cache/binpkgs
#    emerge -qtbk --newuse --deep @world && \
#     emerge -qtbk app-eselect/eselect-repository dev-vcs/git app-portage/flaggie app-portage/gentoolkit app-portage/eix app-editors/vim && \
#     emerge -C app-editors/nano && \
#     mkdir /etc/portage/repos.conf && \
#     eix-update && \
#     eselect repository add azimut git https://github.com/azimut/overlay.git

# RUN --mount=type=bind,target=/var/db/repos/gentoo,source=/var/db/repos/gentoo,from=portage \
#     ls -l /var/cache/binpkgs && \
#     sed -i -e 's#^ID.*#ID=alpine#g' /etc/os-release && \
#     emaint sync -r azimut && \
#     emerge -qtbk =dev-lisp/sbcl-2.1.9::azimut
