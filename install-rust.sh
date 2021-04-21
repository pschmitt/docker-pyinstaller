#!/usr/bin/env bash

case "$(uname -m)" in
  s390*|mips*)
    echo "Sorry. Rustup will not work on this platform. Install skipped" >&2
    exit
    ;;
esac

# Where to put the symlinks
DEST=/usr/local/bin

curl https://sh.rustup.rs -sSf | sh -s -- -y
for file in "${HOME}"/.cargo/bin/*;
do
  ln -sfv "$file" "$DEST"
done
