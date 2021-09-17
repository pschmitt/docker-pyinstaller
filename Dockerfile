ARG BASE_TAG=3.9-buster

FROM python:${BASE_TAG}

ADD install-rust.sh /install-rust.sh

RUN pip install -U pip setuptools wheel && \
    pip install patchelf-wrapper SCons && \
    pip install pyinstaller staticx && \
    /install-rust.sh && \
    rm -f /install-rust.sh

ADD entrypoint.sh /entrypoint.sh

ENV DEPS= HIDDEN_IMPORTS= REQUIREMENTS_FILE=requirements.txt \
    SKIP_PIP_INSTALL_PROJECT= UPDATE_PIP= DIST_PATH= CLEAN= \
    OWNER=1000:1000 \
    STATICX= STATICX_ARGS= STATIX_TARGET= STATICX_OUTPUT=

VOLUME ["/app"]

ENTRYPOINT ["/entrypoint.sh"]

# vim set ft=dockerfile et ts=2 sw=2 :
