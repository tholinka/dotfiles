#!/bin/sh
if type gconftool-2&>/dev/null; then
    export GCONFTOOL="$(type -p gconftool-2)"
fi

echo 85 | Gogh/gogh.sh
