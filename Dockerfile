ARG BASE_TAG=python:3.8-buster

FROM python:${BASE_TAG}

RUN pip install patchelf-wrapper SCons && \
    pip install pyinstaller staticx

ADD entrypoint.sh /entrypoint.sh

ENV DEPS= HIDDEN_IMPORTS= REQUIREMENTS_FILE=requirements.txt \
    STATICX= STATICX_ARGS= STATIX_TARGET= STATICX_OUTPUT=

VOLUME ["/app"]

ENTRYPOINT ["/entrypoint.sh"]

# vim set ft=dockerfile et ts=2 sw=2 :
