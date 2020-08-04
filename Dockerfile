ARG BASE_TAG=python:3.7-stretch

FROM python:${BASE_TAG}

RUN pip install pyinstaller staticx

ADD entrypoint.sh /entrypoint.sh

ENV DEPS= HIDDEN_IMPORTS= REQUIREMENTS_FILE=requirements.txt STATICX= STATICX_ARGS=

VOLUME ["/app"]

ENTRYPOINT ["/entrypoint.sh"]

# vim set ft=dockerfile et ts=2 sw=2 :
