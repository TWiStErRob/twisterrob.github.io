---
title: "Jekyll enhancements for development"
subheadline: "Enhancements to make developing a website easier"
teaser: "Have you ever found that Jekyll or one of its components is lacking a feature?"
category: web
tags:
- jekyll
- liquid
- debug
- efficiency
- workaround
- collection
---

Jekyll is nice if you like the defaults, but as soon as you start customizing you run into walls. Here are some tips to make it less painful.

<!--more-->

{% include toc.md %}

## Continous Development
I'm sure you've met this line if you started <kbd>jekyll serve</kbd> at least once:

> <samp>Regenerating: 1 file(s) changed at 2015-06-09 12:34:56 ... done&nbsp;in&nbsp;3.14&nbsp;seconds.</samp> <cite>output from [watcher.rb](https://github.com/jekyll/jekyll-watch/blob/v1.2.1/lib/jekyll/watcher.rb#L40) in [jekyll-watch](https://github.com/jekyll/jekyll-watch) gem</cite>

Now, if you're like me, you immediate ask the question: <q>What are those files?</q>, especially when it says multiple files changed and you only changed one.

{% highlight ruby %}
removed.each { |file| Jekyll.logger.info("Changes:", "Removed #{file.slice(site.source.length + 1, file.length)}"); }
added.each { |file| Jekyll.logger.info("Changes:", "Added #{file.slice(site.source.length + 1, file.length)}"); }
modified.each { |file| Jekyll.logger.info("Changes:", "Modified #{file.slice(site.source.length + 1, file.length)}"); }
print Jekyll.logger.message("Regenerating:", "#{n} file#{n>1?"s":""} changed at #{t.strftime("%Y-%m-%d %H:%M:%S")} ")
{% endhighlight %}{: title="RUBY_HOME\lib\ruby\gems\2.2.0\gems\jekyll-watch-1.2.1\lib\jekyll\watcher.rb@40"}

{% highlight text %}
...
     Changes: Added _posts/2015-06-09-Jekyll-hacks-for-development
Regenerating: 1 file changed at 2015-06-09 15:18:56 ...done in 3.220606 seconds.
     Changes: Removed _posts/2015-06-09-Jekyll-hacks-for-development
     Changes: Added _posts/2015-06-09-Jekyll-hacks-for-development.md
Regenerating: 2 files changed at 2015-06-09 15:19:00 ...done in 3.286006 seconds.
     Changes: Modified _sass/_09_elements.scss
Regenerating: 1 file changed at 2015-06-09 15:20:27 ...done in 3.239607 seconds.
     Changes: Modified _posts/2015-06-09-Jekyll-hacks-for-development.md
Regenerating: 1 file changed at 2015-06-09 15:20:53 ...done in 3.246334 seconds.
{% endhighlight %}{: title="Resulting log after the change, more informative, isn't it?"}

*The paths are relative to <samp>Auto-regeneration: enabled for '...'</samp>.*

## Debugging Liquid
When copy-pasting-building a site from articles found on the internet you'll most likely find yourself wondering: <q>Why is it not working?</q>  
There's a built-in `| inspect`, but it just dumps the text without any escaping or formatting, messing up HTML pages.  
Luckily Jade Dominguez included a [little plugin](https://github.com/plusjade/jekyll-bootstrap/blob/master/_plugins/debug.rb) in his bootstrap which would come to the rescue in this case. The following is a more advanced version of his plugin.

{% include alert warning='This <strong>is</strong> compatible with GitHub Pages! The default mode of Jekyll is unsafe, but GitHub starts it with <code>--safe</code>. So plugins can be used during local development; just don\'t forget to remove <code> | debug</code>s before commit.' %}

{% highlight ruby %}
{% raw %}
# A simple way to inspect liquid template variables.
# Based on: https://github.com/plusjade/jekyll-bootstrap/blob/master/_plugins/debug.rb
# The filters below can be used anywhere liquid syntax is parsed (templates, includes, posts/pages/collections)

require 'pp'  # obj.pretty_inspect
require 'cgi' # CGI.escape_html

module Jekyll
	# Need to overwrite the inspect methods, because the original uses a strange format
	# and we're trying to output JSON. <> also conflicts with HTML code if output literally.
	class Post
		# Replace original #<Jekyll:Post @id="self.id">
		def inspect
			"{ \"type\": \"Jekyll:Post\", \"id\": #{self.id.inspect} }"
		end
	end
	class Page
		# Replace original #<Jekyll:Page @name="self.name">
		def inspect
			"{ \"type\": \"Jekyll:Page\", \"name\": #{self.name.inspect} }"
		end
	end

	module DebugFilter
		# Returns a highlighted HTML code block displaying the received object.
		# Example usages:
		# * <tt>{{ site.pages | debug }}</tt>
		# * <tt>{{ site.pages | debug: 'pages' }}</tt>
		def debug(obj, label = nil)
			pretty = obj.pretty_inspect
			pretty = pretty.gsub(/\=\>/, ': ') # approximate JSON syntax
			pretty = "#{prefix(obj, label)}\n#{pretty}" # prefix with type
			highlight = Jekyll::Tags::HighlightBlock.new('highlight', 'json', [ pretty, "{% endhighlight %}" ])
			pretty = highlight.render_pygments(pretty, true)
			pretty = highlight.add_code_tag(pretty)
			pretty = pretty.sub(/<div class="highlight">/, "<div class=\"highlight debug\" title=\"#{prefix(obj, label)}\">")
			return pretty
		end

		# Returns a non-highlighted HTML code block displaying the received object.
		# Example usages:
		# * <tt>{{ site.pages | dump_html }}</tt>
		# * <tt>{{ site.pages | dump_html: 'pages' }}</tt>
		def dump_html(obj, label = nil)
			pretty = obj.pretty_inspect
			pretty = CGI.escape_html(pretty)
			pretty = "#{prefix(obj, label)}\n#{pretty}" # prefix with type
			pretty = "<pre class=\"debug\" title=\"#{prefix(obj, label)}\">#{pretty}</pre>"
			return pretty
		end

		# Returns pretty-printed plain text displaying the received object.
		# Example usages:
		# * <tt>{{ site.pages | dump_text }}</tt>
		# * <tt>{{ site.pages | dump_text: 'pages' }}</tt>
		def dump_text(obj, label = nil)
			pretty = obj.pretty_inspect
			return "#{prefix(obj, label)}#{pretty.strip}"
		end

		# Prints pretty-printed plain text displaying the received object to the console.
		# Returns the original object, making it chainable.
		# Example usages:
		# * <tt>{% assign upperTitle = page.title | dump_console | upcase | dump_console %}</tt>
		# * <tt>{% assign upperTitle = page.title | dump_console: 'original' | upcase | dump_console: 'upcased' %}</tt>
		def dump_console(obj, label = nil)
			pretty = obj.pretty_inspect
			puts "#{prefix(obj, label)}#{pretty.strip}"
			return obj
		end

		private
		def prefix(obj, label)
			clazz = "(#{obj.class})" if obj
			label = "#{label}: " if label
			return "#{label}#{clazz}"
		end
	end # DebugFilter
end # Jekyll

Liquid::Template.register_filter(Jekyll::DebugFilter)
{% endraw %}
{% endhighlight %}

### Debugging Example Walkthrough

Suppose there's a [tags data file](http://www.minddust.com/post/tags-and-categories-on-github-pages/) in the [format I suggested](https://github.com/minddust/minddust.github.io/issues/5):
{% highlight yaml %}
tag1:
  name: "Tag 1 Long Name"
tag2:
  name: "Tag 2 Long Name"
{% endhighlight %}{: title="_data/tags.yaml"}

... and you're trying to list all the tags on the site, like [<cite>LovesTha</cite> did](https://github.com/minddust/minddust.github.io/issues/5#issuecomment-125376549):
{% highlight liquid %}
{% raw %}
<ul>
	{% for tag in site.data.tags %}
	<li><a href='/blog/tag/{{ tag }}/'>{{ tag.name }}</a></li>
	{% endfor %}
</ul>
{% endraw %}
{% endhighlight %}{: title="Problematic code"}

{% highlight html %}
<ul>
	<li><a href='/blog/tag/tag1{"name"=>"Tag 1 Long Name"}/'></a></li>
	<li><a href='/blog/tag/tag2{"name"=>"Tag 2 Long Name"}/'></a></li>
</ul>
{% endhighlight %}{: title="Resulting HTML"}

For some reason `{%raw%}{{tag}}{%endraw%}` comes up as <samp>tag1{"name"=>"Tag&nbsp;1 Long&nbsp;Name"}</samp> instead of the expected <samp>tag1</samp> and `{%raw%}{{tag.name}}{%endraw%}` is empty.  
Let's augment the code to see what's going wrong (the argument to `debug` and `dump_*` is optional):

{% highlight liquid %}
{% raw %}
{{ site.data.tags| debug: "data.tags" }}
<ul>
	{% for tag in site.data.tags %}
	<li><a href='/blog/tag/{{ tag }}/'>{{ tag.name| dump_text }}</a>{{ tag| dump_html: forloop.index }}</li>
	{% endfor %}
</ul>
{% endraw %}
{% endhighlight %}{: title="Augmented code"}

... and here's how it looks like on the page:

<div class="panel">
<div class="highlight debug"><pre><code class="language-json" data-lang="json"><span class="err">data.tags:</span><span class="err">(Hash)</span>
<span class="p">{</span><span class="nt">"tag1"</span><span class="p">:</span> <span class="p">{</span><span class="nt">"name"</span><span class="p">:</span> <span class="s2">"Tag 1 Long Name"</span><span class="p">},</span> <span class="nt">"tag2"</span><span class="p">:</span> <span class="p">{</span><span class="nt">"name"</span><span class="p">:</span> <span class="s2">"Tag 2 Long Name"</span><span class="p">}}</span></code></pre></div>
<ul>
	<li><a href="/blog/tag/.../">nil</a><pre class="debug">1: (Array)
["tag1", {"name"=&gt;"Tag 1 Long Name"}]</pre></li>
	<li><a href="/blog/tag/.../">nil</a><pre class="debug">2: (Array)
["tag2", {"name"=&gt;"Tag 2 Long Name"}]</pre></li>
</ul>
</div>

From the above the following is revealed:

 * the iteration was correctly going through the Hash (map) as expected
 * `{%raw%}{{tag.name}}{%endraw%}` is <samp>nil</samp> displayed as an empty string
 * at each iteration <var>tag</var> is an array and not the key of the hash

 {% include alert tip='In Liquid a hash entry is stored as <samp>[key, value]</samp>; compare to <a href="https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/for...in#Examples" target="_blank">for..in loop in JavaScript</a>.' %}

Based on the above it's clear that the code must be changed to correctly read the value from the entry:

{% highlight liquid %}
{% raw %}
{% for tag_entry in site.data.tags %}
    {% assign tag_key = tag_entry[0] %}
    {% assign tag_data = tag_entry[1] %}
    <li><a href="/blog/tag/{{ tag_key }}/">{{ tag_data.name }}</a></li>
{% endfor %}
{% endraw %}
{% endhighlight %}{: title="Fixed code"}

### More Debugging options

In case you're generating something other than HTML, `dump_text` and `dump_console` come in handy.  
{% include alert warning="Different languages have different rules, make sure you escape everything accordingly.<br/>For example XML comments cannot contain <samp>--</samp> so it's required to strip (<code>|&nbsp;remove:&nbsp;'--'</code>) or collapse them (<code>|&nbsp;replace:&nbsp;'--',&nbsp;'-'</code>) to make parsers happy." %}

{% highlight xml %}
{% raw %}
<url>
	<!-- {{ link | dump_text | remove: '--' }} -->
	<loc>{{ site.url }}{{ site.baseurl }}{{ link.url | dump_console: "original" | remove: 'index.html' | dump_console: "stripped" }}</loc>
	...
</url>
{% endraw %}
{% endhighlight %}{: title="Example debugging of sitemap.xml"}

{% highlight xml %}
<url>
	<!-- (Hash){...
		"dir"=>"/blog",
		"name"=>"index.html",
		"path"=>"blog/index.html",
		"url"=>"/blog/index.html"} -->
	<loc>http://localhost:4000/dev/blog/</loc>
{% endhighlight %}{: title="Sample from sitemap.xml"}

{% highlight text %}
     Regenerating: 1 file changed at 2015-07-29 14:16:06
original: (String)"/blog/index.html"
stripped: (String)"/blog/"
original: (String)"/blog/tags/"
stripped: (String)"/blog/tags/"
...
{% endhighlight %}{: title="Sample console dump from sitemap.xml"}

{% include alert tip='It\'s also worth looking at <a href="https://github.com/octopress/debugger">Octopress Debugger</a> which offers different features.' %}

## Hidden Gems

### Filter Documentation
Not all the filters documented are available when using an older version of either [Jekyll](http://jekyllrb.com/docs/templates/#filters) or [Liquid](https://docs.shopify.com/themes/liquid-documentation/filters). The most relevant documentation and list of filters can be found in your local Ruby installation:

 * Jekyll: <samp>lib/ruby/gems/2.2.0/gems/jekyll-2.4.0/lib/jekyll/filters.rb</samp>
 * Liquid <samp>lib/ruby/gems/2.2.0/gems/liquid-2.6.2/lib/liquid/standardfilters.rb</samp>

### Working With Arrays
By default Liquid doesn't have array manipulation, but our friends and Jekyll were kind enough to implement it, and we can even create new arrays with the `split` trick.

{% highlight liquid %}
{% raw %}
{% assign r = "," | split: ","    | dump_console: "new array" %}
{% assign r = r   | push: "c"     | dump_console: "insert last" %}
{% assign r = r   | push: "d"     | dump_console: "insert last" %}
{% assign r = r   | unshift: "b"  | dump_console: "insert first" %}
{% assign r = r   | unshift: "a"  | dump_console: "insert first" %}
{% assign r = r   | shift: 2      | dump_console: "remove first 2" %}
{% assign r = r   | pop: 1        | dump_console: "remove last 1" %}
{% assign r = r   | unshift: "z"  | dump_console: "insert first" %}
{% assign r = r   | push: "a"     | dump_console: "insert last" %}
{% assign r = r   | sort          | dump_console: "order by contents" %}
{% endraw %}
{% endhighlight %}{: title="Array Manipulation"}

{% highlight bash %}
insert last: (Array)["c"]
insert last: (Array)["c", "d"]
insert first: (Array)["b", "c", "d"]
insert first: (Array)["a", "b", "c", "d"]
remove first 2: (Array)["c", "d"]
remove last 1: (Array)["c"]
insert first: (Array)["z", "c"]
insert last: (Array)["z", "c", "a"]
order by contents: (Array)["a", "c", "z"]
{% endhighlight %}{: title="Output"}


## Liquid Error Messages
{% include alert todo='Maybe http://saimonmoore.com/tumblog/200612/debugging-liquid-templates.html can help with this.' %}
Among other modifications made to my tags display, I wanted to sort tags case insensitively and I got the following error message:

> Liquid Exception: no implicit conversion from nil to integer <cite>in tags.html</cite>

Not knowing which line gave the error, I tried to fix and remove parts of the file which were dealing with numbers like <samp>0&nbsp;<&nbsp;post.size</samp>. After many minutes of trying I found out that the above line gives the message and the problem is that I missed the quotes on `downcase`: quotes are required for map as method are called via reflection.

{% highlight liquid %}
{%raw%}
{% assign tag_words = site_tags | split: ',' | map: downcase | sort %}
{%endraw%}
{% endhighlight %}
