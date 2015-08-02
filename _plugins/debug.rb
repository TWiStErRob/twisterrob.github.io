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
			#pretty = "#{prefix(obj, label)}\n#{pretty}" # prefix with type
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
			#pretty = "#{prefix(obj, label)}\n#{pretty}" # prefix with type
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
