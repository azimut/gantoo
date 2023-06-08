# syntax = docker/dockerfile:1.3

FROM gentoo/portage:20230605 as portage
FROM gentoo/stage3:musl-20230605 as base

ENV FEATURES='nodoc noinfo noman -seccomp -ipc-sandbox -mount-sandbox -network-sandbox -pid-sandbox -sandbox -usersandbox' \
    USE='static-libs bindist' \
    VIDEO_CARDS=''

ADD binpkgs.tar /var/cache

COPY etc /etc/

RUN --mount=type=bind,target=/var/db/repos/gentoo,source=/var/db/repos/gentoo,from=portage \
    set -x && \
    ls -l /var/cache/binpkgs && \
    emerge --quiet-build=y -j2 -l2 -bk --newuse --deep @world && \
    emerge --quiet-build=y -j2 -l2 -bk app-eselect/eselect-repository dev-vcs/git app-portage/flaggie app-portage/gentoolkit app-portage/eix app-editors/vim && \
    ls -l /var/cache/binpkgs && \
    emerge -C app-editors/nano && \
    mkdir /etc/portage/repos.conf && \
    eix-update && \
    echo REMOTE_LIST_URI=https://api.gentoo.org/overlays/repositories.xml >> /etc/eselect/repository.conf && \
    eselect repository add azimut git https://github.com/azimut/overlay.git && \
    sed -i -e 's#^ID.*#ID=alpine#g' /etc/os-release

RUN --mount=type=bind,target=/var/db/repos/gentoo,source=/var/db/repos/gentoo,from=portage \
    set -x && \
    ls -l /var/cache/binpkgs && \
    emaint sync -r azimut && \
    emerge --quiet-build=y -j2 -l2 -bk =dev-lisp/sbcl-2.1.9-r1::azimut
