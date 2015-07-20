@echo off
setlocal
if "%JEKYLL_ENV%"=="" set JEKYLL_ENV=development
set JEKYLL_CONFIGS=_config.yml,%JEKYLL_CONFIGS%
set SKIP=--skip-initial-build
if "%1"=="noskip" set SKIP=
shift
unsubst bundle exec jekyll serve --config %JEKYLL_CONFIGS% --trace %SKIP% %*
rem --verbose
