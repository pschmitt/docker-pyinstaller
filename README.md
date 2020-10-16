# pyinstaller

[![GitHub Actions CI](https://github.com/pschmitt/docker-pyinstaller/workflows/GitHub%20Actions%20CI/badge.svg)](https://github.com/pschmitt/docker-pyinstaller/actions?query=workflow%3A%22GitHub+Actions+CI%22)
[![Docker Hub](https://img.shields.io/docker/pulls/pschmitt/pyinstaller)](https://hub.docker.com/r/pschmitt/pyinstaller)

With this container you can run pyinstaller over your projects. It uses the oldest possible debian version (ie. docker tag) so that the resulting binaries are compatible with a wider range of linux OSes.

## Usage example

```bash
docker run -it --rm \
  -v "$PWD:/app" \
  -e "DEPS=libsasl2-dev libssl-dev libldap2-dev" \
  -e REQUIREMENTS_FILE=requirements.txt \
  pschmitt/pyinstaller:3.7 \
    --hidden-import=pkg_resources.py2_warn \
    app.py
```

## Static binaries

**WARNING**: This is currently only supported on amd64.

To run staticx on the binary produced by pyinstaller you need can make use the `STATICX_*` environment variables:

- `STATICX`: Enable staticx. Set to any value. Unset by default.
- `STATICX_ARGS`: Set staticx's arguments. Eg: `--strip`. Unset by default.
- `STATICX_TARGET`: Set the name of the binary in the `dist/` directory which we should run staticx against. Default to the first file in `dist/`.
- `STATIC_OUTPUT`: Name of the resulting binary. Defaults to `${STATICX_TARGET}_static`.
