#!/usr/bin/env bash

case "$(uname -m)" in
  s390*|mips*)
    echo "Sorry. Rustup will not work on this platform. Install skipped" >&2
    exit
    ;;
esac

EXTRA_ARGS=()

# Check if we are inside a i386 image and set the rust toolchain accordingly
# When inside an i386 container on an amd64 host uname -m will return x64_64
# hence the file check
if file /usr/bin/file | grep -q "Intel 80386"
then
  EXTRA_ARGS+=(--default-host i686-unknown-linux-gnu)
fi

# Where to put the symlinks
DEST=/usr/local/bin

curl https://sh.rustup.rs -sSf | sh -s -- -y "${EXTRA_ARGS[@]}"
for file in "${HOME}"/.cargo/bin/*;
do
  ln -sfv "$file" "$DEST"
done
