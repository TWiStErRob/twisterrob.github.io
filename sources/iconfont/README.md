# Icon font

The site builds its icon font from the SVGs in `vectors/`. This build uses
Ruby 2.7.8 from [`.ruby-version`](.ruby-version), separately from the Ruby
version used to build the site.

## Requirements

- Ruby 2.7.8 and RubyGems 3.4.22. RubyGems 3.5 no longer supports Ruby 2.7.
- FontCustom 2.0.0 and FontForge.
- `sfnt2woff` and `woff2_compress` on `PATH` to generate both WOFF formats.

CI installs these tools on Ubuntu 24.04 using
[`install-fontcustom.sh`](../../.github/workflows/install-fontcustom.sh).
For a local build, install the platform versions of FontForge and the WOFF
tools, then install FontCustom with the iconfont Ruby version active:

```shell
gem update --system 3.4.22
gem install fontcustom --version 2.0.0
```

## Build

From the repository root, run:

```shell
cd sources/iconfont
fontcustom compile
```

Alternatively, run `./gradlew font` from the repository root (`gradlew.bat font`
on Windows). The Gradle task also runs FontCustom in this directory.

The generated files are `../../_sass/_iconfont.scss`,
`../../assets/fonts/iconfont.{eot,svg,ttf,woff,woff2}`, and
`iconfont-preview.html`. These outputs are ignored by Git.
