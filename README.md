Visit [twisterrob.net](https://www.twisterrob.net).


# Development Install
Requires both [ruby](http://rubyinstaller.org/downloads/) and [devkit](http://rubyinstaller.org/downloads/) on [Windows 7 x64](http://corlewsolutions.com/articles/article-19-install-ruby-on-windows-7-32-bit-or-64-bit) to install native extensions.


## Ruby
Download `ruby-2.1.3-x64-mingw32.7z` from [bintray](https://bintray.com/oneclick/rubyinstaller/rubyinstaller/2.1.3/view#files).
Download Latest DevKit from [bintray](https://bintray.com/oneclick/rubyinstaller/DevKit/view)
Note: the version number should match closely what's on: https://pages.github.com/versions/


## First time

```shell
me@devkit$ ruby dk.rb init
me@devkit$ edit config.yml # add ruby directory
me@devkit$ ruby dk.rb install
me@anywhere$ gem install bundler
me@website$ bundle install # takes about 5 minutes
```

In case of `SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed` follow [these instructions](https://gist.github.com/luislavena/f064211759ee0f806c88).
If there's the same SSL issue, for example when using `jekyll-gist`, then [try this](https://gist.github.com/fnichol/867550#the-manual-way-boring).


## Run

```shell
me@windows$ unsubst bundle exec jekyll serve --config _config.yml,_config_local.yml,_config_dev.yml --trace --skip-initial-build --incremental
me@windows$ gradle serve dev noskip
```

## Usage

Check if site build successfully before each commit

```shell
me@webiste$ gradle preCommitServe local
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

## TODO

GHPages:
 * 161 Whitelist jekyll-octicons (#483) https://github.com/github/pages-gem/pull/483
 * 86-192: rouge 1.11.1 -> 2.2.1
 * kramdown 1.13.2 -> 1.17.0

Jekyll 3.5
 * Sitemaps for static files
 * Liquid 4: https://github.com/Shopify/liquid/blob/main/History.md#400--2016-12-14--branch-4-0-stable
 * Jekyll now uses Liquid 4, the latest! It comes with whitespace control, new filters concat and compact, loop performance improvements and many fixes
 * Pages, posts, and other documents can now access layout variables via {{ layout }}.
 * The gems key in the _config.yml is now plugins.
 * Filters like sort now allow you to sort based on a subvalue, e.g. {% assign sorted = site.posts | sort: "image.alt_text" %}.
 * layout: null -> layout: none (null = default, none = no layout)

Jekyll 3.6
 * Rouge 2 support, but note you can continue to use Rouge 1

Jekyll 3.7
 * --livereload
 * slugify latin
 * collections folder (https://jekyllrb.com/docs/collections/)
 * Ruby 2.5.3

Finished reading news <3.8 and changelog <=3.8

These two end up in sitemap after update:
 * /dev/assets/css/style.css
 * /dev/redirects.json

dev > sass > line_numbers: true is broken after update (generated CSS files no longer have line numbers)
ref https://github.com/jekyll/jekyll-sass-converter/blob/master/lib/jekyll/converters/scss.rb#L48

dev > sass > sourcemap is disabled, check if it can be enabled

new RegExp('vegetarian is broken in javascript, report backslash issue
contact wasn't working, now it is? (probably should be generated in debug)
shell code formatting lost user@machine$ formatting

https://github.com/jekyll/jekyll/pull/6384/files#diff-514abd885acda367325e5236a9be3192R68
https://github.com/kacperduras/disqus-for-jekyll

## Origin

This website is based on the [Feeling Responsive theme](https://phlow.github.io/feeling-responsive/) by [Moritz »mo.« Sauer](https://github.com/Phlow/feeling-responsive) // [Phlow.de](https://phlow.de)
