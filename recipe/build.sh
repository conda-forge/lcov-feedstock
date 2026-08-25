#!/usr/bin/env bash

set +x

# The release archive already contains generated man and HTML documentation.
touch doc_finished

make --old-file=doc_finished install \
    PREFIX="${PREFIX}" \
    LCOV_PERL_PATH= \
    LCOV_PYTHON_PATH=

# perl2lcov requires Devel::Cover, which is not packaged on conda-forge.
# Do not expose a command that cannot start in the packaged environment.
rm "${PREFIX}/bin/perl2lcov"
rm "${PREFIX}/share/man/man1/perl2lcov.1"
