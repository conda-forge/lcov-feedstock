@echo ON
setlocal enabledelayedexpansion

make install ^
    PREFIX=%LIBRARY_PREFIX% ^
    VERSION=%PKG_VERSION% ^
    RELEASE=1 ^
    FULL=%PKG_VERSION% ^
    LCOV_PERL_PATH=
if %ERRORLEVEL% NEQ 0 exit 1
cp %RECIPE_DIR%\lcov.bat %LIBRARY_BIN%
if %ERRORLEVEL% NEQ 0 exit 1
