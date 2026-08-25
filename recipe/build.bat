@echo ON
setlocal enabledelayedexpansion

for /f "delims=" %%i in ('cygpath -u "%LIBRARY_PREFIX%"') do set "LCOV_PREFIX=%%i"
touch doc_finished
if %ERRORLEVEL% NEQ 0 exit 1

make --old-file=doc_finished install ^
    PREFIX=%LCOV_PREFIX% ^
    LCOV_PERL_PATH= ^
    LCOV_PYTHON_PATH=
if %ERRORLEVEL% NEQ 0 exit 1

for %%F in (lcov genhtml geninfo genpng gendesc perl2lcov llvm2lcov) do (
    copy "%RECIPE_DIR%\perl-tool.bat" "%LIBRARY_BIN%\%%F.bat"
    if !ERRORLEVEL! NEQ 0 exit 1
)
for %%F in (py2lcov xml2lcov) do (
    copy "%RECIPE_DIR%\python-tool.bat" "%LIBRARY_BIN%\%%F.bat"
    if !ERRORLEVEL! NEQ 0 exit 1
)
