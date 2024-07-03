set -eo pipefail

mkdir -p fontcustom && cd fontcustom

# Workaround for
# > Error installing fontcustom:
# > The last version of ffi (~> 1.0) to support your Ruby & RubyGems was 1.17.0.
# > Try installing it with `gem install ffi -v 1.17.0` and then running the current command again
# > ffi requires RubyGems version >= 3.3.22. The current RubyGems version is 3.1.6.
# > Try 'gem update --system' to update RubyGems itself.
#
# Fixing the version to the latest compatible with Ruby 2.x:
# > Error installing rubygems-update:
# > There are no versions of rubygems-update (= 3.5.14) compatible with your Ruby & RubyGems
# > rubygems-update requires Ruby version >= 3.0.0. The current ruby version is 2.7.8.225.
gem install rubygems-update -v 3.3.22
gem update --system
gem install fontcustom --version 2.0.0

sudo apt-get install fontforge=1:20201107~dfsg-4build1

git -c advice.detachedHead=false clone --branch v1.3.1 --depth 1 https://github.com/bramstein/sfnt2woff-zopfli.git \
  && pushd sfnt2woff-zopfli \
  && make \
  && mv sfnt2woff-zopfli sfnt2woff \
  && echo "${PWD}" >> "${GITHUB_PATH}" \
  && popd

git -c advice.detachedHead=false clone --branch v1.0.2 --depth 1 --recursive https://github.com/google/woff2.git \
  && pushd woff2 \
  && make clean all \
  && echo "${PWD}" >> "${GITHUB_PATH}" \
  && popd
