---
title: "Homebrew Jekyll enhancements for easier development"
subheadline: "Work around the quirks"
teaser: "Jekyll is nice if you like the defaults, but as soon as you start customizing you run into walls. Here are some tips to make it less painful."
category: web
tags:
- Jekyll
- Ruby
- enhancement
---

<!--more-->

## Continous Development
I'm sure you've met this line if you started `jekyll serve` at least once:

> Regenerating: 1 file(s) changed at 2015-06-11 15:36:01 ...done in 3.303007 seconds.
<cite>output from [watcher.rb](https://github.com/jekyll/jekyll-watch/blob/v1.2.1/lib/jekyll/watcher.rb#L40) in [jekyll-watch](https://github.com/jekyll/jekyll-watch) gem</cite>

Now, if you're like me, you immediate ask the question: "What are those files?", especially when it says multiple files changed and you only changed one.

{% highlight ruby %}
removed.each { |file| Jekyll.logger.info("Changes:", "Removed #{file.slice(site.source.length + 1, file.length)}"); }
added.each { |file| Jekyll.logger.info("Changes:", "Added #{file.slice(site.source.length + 1, file.length)}"); }
modified.each { |file| Jekyll.logger.info("Changes:", "Modified #{file.slice(site.source.length + 1, file.length)}"); }
print Jekyll.logger.message("Regenerating:", "#{n} file#{n>1?"s":""} changed at #{t.strftime("%Y-%m-%d %H:%M:%S")} ")
{% endhighlight %}{: title="RUBY_HOME\lib\ruby\gems\2.2.0\gems\jekyll-watch-1.2.1\lib\jekyll\watcher.rb@40"}

{% highlight text %}
...
     Changes: Added _posts/2015-06-11-Jekyll-hacks-for-development
Regenerating: 1 file(s) changed at 2015-06-11 15:18:56 ...done in 3.220606 seconds.
     Changes: Removed _posts/2015-06-11-Jekyll-hacks-for-development
     Changes: Added _posts/2015-06-11-Jekyll-hacks-for-development.md
Regenerating: 2 file(s) changed at 2015-06-11 15:19:00 ...done in 3.286006 seconds.
     Changes: Modified _sass/_09_elements.scss
Regenerating: 1 file(s) changed at 2015-06-11 15:20:27 ...done in 3.239607 seconds.
     Changes: Modified _posts/2015-06-11-Jekyll-hacks-for-development.md
Regenerating: 1 file(s) changed at 2015-06-11 15:20:53 ...done in 3.246334 seconds.
{% endhighlight %}{: title="Resulting log after the change, more informative, isn't it?"}

*The paths are relative to `Auto-regeneration: enabled for '...'`.*
