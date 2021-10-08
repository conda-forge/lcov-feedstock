@echo ON
setlocal enabledelayedexpansion

 >.version echo VERSION=%PKG_VERSION%
>>.version echo RELEASE=1
>>.version echo FULL=%PKG_VERSION%
make install PREFIX=%LIBRARY_PREFIX% LCOV_PERL_PATH=
cp %RECIPE_DIR%\lcov.bat %LIBRARY_BIN%
