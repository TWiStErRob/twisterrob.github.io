set -eo pipefail
mkdir -p fontcustom && cd fontcustom
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
