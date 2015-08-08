rmdir /Q /S .sass-cache
rmdir /Q /S _site
ruby sources/jobs/strip-frontmatter.rb "%~dp0sources/jobs" "%~dp0_jobs"
