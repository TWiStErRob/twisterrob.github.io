@echo off
setlocal
set JEKYLL_ENV=development
set JEKYLL_CONFIGS=_config_local.yml,_config_dev.yml

set TARGET=".fast-dev"
xcopy *.yml %TARGET% /F /I /H /D /K
xcopy *.bat %TARGET% /F /I /H /D /K
xcopy Gemfile* %TARGET% /F /I /H /D /K
xcopy _data %TARGET%\_data /F /I /S /H /E /D /K
xcopy _sass %TARGET%\_sass /F /I /S /H /E /D /K
xcopy assets %TARGET%\assets /F /I /S /H /E /D /K
xcopy images %TARGET%\images /F /I /S /H /E /D /K
xcopy _includes %TARGET%\_includes /F /I /S /H /E /D /K
xcopy _layouts %TARGET%\_layouts /F /I /S /H /E /D /K
xcopy _plugins %TARGET%\_plugins /F /I /S /H /E /D /K
mkdir %TARGET%\_posts
mkdir %TARGET%\pages

xcopy pages\root\index.md %TARGET%\pages /F /I /S /H /E /D /K
xcopy _site\assets\css\styles_feeling_responsive.css %TARGET%\assets\css /F /I /S /H /E /D /K
del /F /Q %TARGET%\assets\css\styles_feeling_responsive.scss

cd %TARGET%
call serve %*
