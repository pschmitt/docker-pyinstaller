# pyinstaller

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
