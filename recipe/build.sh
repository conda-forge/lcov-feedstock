#!/usr/bin/env bash

set +x

>.version cat <<EOF
VERSION=${PKG_VERSION}
RELEASE=1
FULL=${PKG_VERSION}
EOF
make install PREFIX=$PREFIX LCOV_PERL_PATH=
