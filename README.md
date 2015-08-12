Visit [twisterrob.net](http://www.twisterrob.net).


# Development Install
Requires both [ruby](http://rubyinstaller.org/downloads/) and [devkit](http://rubyinstaller.org/downloads/) on [Windows 7 x64](http://corlewsolutions.com/articles/article-19-install-ruby-on-windows-7-32-bit-or-64-bit) to install native extensions.


## Ruby
Download `ruby-2.1.3-x64-mingw32.7z` from [bintray](https://bintray.com/oneclick/rubyinstaller/rubyinstaller/2.1.3/view#files).
Download Latest DevKit from [bintray](https://bintray.com/oneclick/rubyinstaller/DevKit/view)
Note: the version number should match closely what's on: https://pages.github.com/versions/


## First time

```bash
devkit$ ruby dk.rb init
devkit$ edit config.yml # add ruby directory
devkit$ ruby dk.rb install
anywhere$ gem install bundler
website$ bundle install # takes about 5 minutes
```

In case of `SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed` follow [these instructions](https://gist.github.com/luislavena/f064211759ee0f806c88).


## Run

```bash
windows$ cls && dev noskip
```

## Usage
Update dependencies occasionally by

```bash
website$ bundle update
```

Check if site build successfully before each commit

```bash
webiste$ cls && clean && local noskip
```
