source 'https://rubygems.org'

# See https://github.com/TWiStErRob/twisterrob.github.io#upgrade
# Current latest version: https://pages.github.com/versions/
# For some reason omitting the version defaults to 0.
# TODO decouple, because it's unmaintained https://github.com/github/pages-gem/issues/890
# Use specific ref, because last release was more than a year ago, master seems to have support for Ruby 3.3 and Jekyll 3.9.4.
gem 'github-pages', :github => 'github/pages-gem', :ref => '974872fe73f8ec0b704e48f5c1f150df7a508e01', group: :jekyll_plugins

# https://jekyllrb.com/docs/windows/#auto-regeneration
# For --watch to work on Windows.
gem 'wdm', '>= 0.1.1' if Gem.win_platform?

# Added to silence the warning:
# > To use retry middleware with Faraday v2.0+, install `faraday-retry` gem
# Not sure what it does, because I don't use octokit directly:
# https://github.com/octokit/octokit.rb/discussions/1486
gem 'faraday-retry', '~> 2.2.0'
