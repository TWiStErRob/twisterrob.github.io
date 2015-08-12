@echo off

if "%1"=="fast" (
	copy _site\assets\css\styles_feeling_responsive.css assets\css\styles_feeling_responsive.css && move assets\css\styles_feeling_responsive.scss assets\css\_styles_feeling_responsive.scss
	goto :eof
)
if "%1"=="slow" (
	move assets\css\_styles_feeling_responsive.scss assets\css\styles_feeling_responsive.scss && del assets\css\styles_feeling_responsive.css
	goto :eof
)

setlocal
set JEKYLL_ENV=development
set JEKYLL_CONFIGS=_config_local.yml,_config_dev.yml
call serve %*
rem --verbose