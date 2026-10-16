Visit [twisterrob.net](https://www.twisterrob.net).


# Development Install
Install [Ruby+Devkit](https://rubyinstaller.org/downloads/) on Windows to build the site and its native gems.
Use the version in [`.ruby-version`](.ruby-version) to match CI.
To regenerate the icon font, see [the iconfont build instructions](sources/iconfont/README.md).


## First time

```shell
ridk install # Select the MSYS2 and MINGW development toolchain.
gem install bundler
bundle install # Takes about 5 minutes the first time on a clean Ruby.
```

In case of `SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed` follow [these instructions](https://gist.github.com/luislavena/f064211759ee0f806c88).
If there's the same SSL issue, for example when using `jekyll-gist`, then [try this](https://gist.github.com/fnichol/867550#the-manual-way-boring).


## Run

```shell
me@windows$ unsubst bundle exec jekyll serve --config _config.yml,_config_local.yml,_config_dev.yml --trace --skip-initial-build --incremental
me@windows$ gradlew serve dev noskip
```

## Usage

Check if site build successfully before each commit

```shell
me@webiste$ gradlew preCommitServe local
```

## Upgrade

 * Change `gem 'github-pages'` version to [GitHub version](https://pages.github.com/versions/)
 * `bundle update`, watch for these lines and read release notes:
   * Fetching github-pages 192 (was 127)  
     * https://github.com/github/pages-gem/releases
   * Fetching jekyll 3.7.4 (was 3.4.1)
     * https://jekyllrb.com/news/releases/
     * https://jekyllrb.com/docs/history/
   * Fetching liquid 4.0.4 (was 4.0.3)
   * Fetching kramdown 2.3.2 (was 2.3.1)
   * Fetching rouge 3.26.0 (was 3.25.0)
   * Ruby
      * If it asks for `ridk install`, choose _"MSYS2 and MINGW development toolchain"_ and install to `%RUBY_HOME%\msys64`.
 * Check if https://help.github.com/articles/configuring-jekyll/#configuration-settings-you-cannot-change has changed

## Origin

This website is based on the [Feeling Responsive theme](https://phlow.github.io/feeling-responsive/) by [Moritz »mo.« Sauer](https://github.com/Phlow/feeling-responsive) // [Phlow.de](https://phlow.de)
