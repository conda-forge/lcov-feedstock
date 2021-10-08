#!/usr/bin/env bash

set +x

make install \
    PREFIX=${PREFIX} \
    VERSION=${PKG_VERSION} \
    RELEASE=1 \
    FULL=${PKG_VERSION} \
    LCOV_PERL_PATH=
