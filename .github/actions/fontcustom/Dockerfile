# Test with `docker build -t fontcustom . && docker run --rm -it fontcustom`
FROM ruby:2.7.8-alpine

# https://wiki.alpinelinux.org/wiki/GCC, including make; needed for custom builds and gem installs.
RUN apk add --no-cache build-base
# Needed for custom builds of sfnt2woff and woff2.
RUN apk add --no-cache git

# Workaround for
# > Error installing fontcustom:
# > The last version of ffi (~> 1.0) to support your Ruby & RubyGems was 1.17.0.
# > Try installing it with `gem install ffi -v 1.17.0` and then running the current command again
# > ffi requires RubyGems version >= 3.3.22. The current RubyGems version is 3.1.6.
# > Try 'gem update --system' to update RubyGems itself.
# As an additional workaround for "gem update --system" erroring with:
# > Error installing rubygems-update:
# > There are no versions of rubygems-update (= 3.5.14) compatible with your Ruby & RubyGems
# > rubygems-update requires Ruby version >= 3.0.0. The current ruby version is 2.7.8.225.
# downgrading to specific version because Rubygems 3.5 dropped support for Ruby 2.7.x
# https://blog.rubygems.org/2023/12/15/3.5.0-released.html
RUN gem update --system 3.4.22

# Install fontcustom with all required dependencies (fontforge, python2, sfnt2woff, woff2).
RUN gem install fontcustom --version 2.0.0
RUN apk add --no-cache fontforge --repository=https://dl-cdn.alpinelinux.org/alpine/v3.17/community
RUN apk add --no-cache python2   --repository=https://dl-cdn.alpinelinux.org/alpine/v3.15/community

WORKDIR /tmp
RUN git -c advice.detachedHead=false clone --branch v1.3.1 --depth 1 https://github.com/bramstein/sfnt2woff-zopfli.git \
  && cd sfnt2woff-zopfli \
  && make \
  && mv sfnt2woff-zopfli sfnt2woff
ENV PATH="$PATH:/tmp/sfnt2woff-zopfli"

# Alternatively: RUN apk add --no-cache woff2
WORKDIR /tmp
RUN git -c advice.detachedHead=false clone --branch v1.0.2 --depth 1 --recursive https://github.com/google/woff2.git \
  && cd woff2 \
  && make clean all
ENV PATH="$PATH:/tmp/woff2"

COPY fontcustom.sh entrypoint.sh
ENTRYPOINT ["/tmp/entrypoint.sh"]
