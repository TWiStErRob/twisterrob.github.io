@echo off
setlocal
set JEKYLL_ENV=development
set JEKYLL_CONFIGS=_config_local.yml,_config_dev.yml
call serve %*
rem --verbose