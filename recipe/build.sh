#!/usr/bin/env bash

set +x

# The release archive already contains generated man and HTML documentation.
touch doc_finished

make --old-file=doc_finished install \
    PREFIX="${PREFIX}" \
    LCOV_PERL_PATH= \
    LCOV_PYTHON_PATH=
