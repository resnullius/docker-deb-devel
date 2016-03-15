#!/usr/bin/env sh

sh /bin/setup-system.sh
abuild-keygen -n
sudo cp "$HOME"/.abuild/*.rsa* /opt/keys
