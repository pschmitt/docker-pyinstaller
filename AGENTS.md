# Agent notes

This repository builds a container image with PyInstaller and staticx for
producing binaries with broad Linux compatibility.

- Build with `docker build` and validate using a small disposable Python
  project. Do not copy private files or credentials into the build context.
- The push workflow builds the image. Do not change publication settings
  without an explicit request.
- Before changing CI, check for reusable workflows or actions in
  [ci-workflows](https://github.com/pschmitt/ci-workflows) and preserve the
  workflow's current behavior and checks.
