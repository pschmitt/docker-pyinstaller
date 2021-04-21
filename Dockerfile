ARG BASE_TAG=3.9-buster

FROM python:${BASE_TAG}

RUN pip install -U pip setuptools wheel && \
    pip install patchelf-wrapper SCons && \
    PYINSTALLER_RELEASE="$(git ls-remote --tags https://github.com/pyinstaller/pyinstaller | sort --version-sort -k 2 | tail -1 | sed -rn 's|.*refs/tags/v?([^\^]+)(\^\{\})?|\1|p')"; \
    pip install "https://github.com/pyinstaller/pyinstaller/releases/latest/download/pyinstaller-${PYINSTALLER_RELEASE}.tar.gz" && \
    pip install staticx

ADD entrypoint.sh /entrypoint.sh

ENV DEPS= HIDDEN_IMPORTS= REQUIREMENTS_FILE=requirements.txt \
    SKIP_PIP_INSTALL_PROJECT= UPDATE_PIP= \
    STATICX= STATICX_ARGS= STATIX_TARGET= STATICX_OUTPUT=

VOLUME ["/app"]

ENTRYPOINT ["/entrypoint.sh"]

# vim set ft=dockerfile et ts=2 sw=2 :
