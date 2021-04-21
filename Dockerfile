ARG BASE_TAG=3.9-buster

FROM python:${BASE_TAG}

RUN pip install -U pip setuptools wheel && \
    pip install patchelf-wrapper SCons && \
    pip install pyinstaller staticx && \
    curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    for file in $HOME/.cargo/bin/*; \
    do \
      ln -sfv "$file" /usr/local/bin; \
    done


ADD entrypoint.sh /entrypoint.sh

ENV DEPS= HIDDEN_IMPORTS= REQUIREMENTS_FILE=requirements.txt \
    SKIP_PIP_INSTALL_PROJECT= UPDATE_PIP= \
    STATICX= STATICX_ARGS= STATIX_TARGET= STATICX_OUTPUT=

VOLUME ["/app"]

ENTRYPOINT ["/entrypoint.sh"]

# vim set ft=dockerfile et ts=2 sw=2 :
