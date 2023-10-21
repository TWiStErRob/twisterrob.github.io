source 'https://rubygems.org'

# See https://github.com/TWiStErRob/twisterrob.github.io#upgrade
# Current latest version: https://pages.github.com/versions/
# For some reason omitting the version defaults to 0.
gem 'github-pages', '= 228', group: :jekyll_plugins

# http://jekyllrb.com/docs/windows/#auto-regeneration
# For --watch to work on Windows.
gem 'wdm', '>= 0.1.1' if Gem.win_platform?

# Added to silence the warning:
# > To use retry middleware with Faraday v2.0+, install `faraday-retry` gem
# Not sure what it does, because I don't use octokit directly:
# https://github.com/octokit/octokit.rb/discussions/1486
# TODEL condition; it was added as a workaround for https://github.com/actions/jekyll-build-pages/issues/104
gem 'faraday-retry', '~> 2.2.0' if ENV["GITHUB_ACTIONS"] != "true"
