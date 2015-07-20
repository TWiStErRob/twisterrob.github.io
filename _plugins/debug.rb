# A simple way to inspect liquid template variables.
# Usage:
#		Can be used anywhere liquid syntax is parsed (templates, includes, posts/pages)
#		{{ site | debug }}
#		{{ site.posts | debug }}
#		{{ site.posts | map: 'to_liquid' | debug, true }}
#		{{ site.posts | map: 'to_liquid' | debug_text }}
#
require 'pp'
require 'cgi'
module Jekyll
	# Need to overwrite the inspect method here because the original
	# uses < > to encapsulate the psuedo post/page objects in which case
	# the output is taken for HTML tags and hidden from view.
	#
	class Post
		def inspect
			"{ \"type\": \"Jekyll:Post\", \"id\": #{self.id.inspect} }"
		end
	end
	
	class Page
		def inspect
			"{ \"type\": \"Jekyll:Page\", \"id\": #{self.name.inspect} }"
		end
	end
	
end # Jekyll
	
module Jekyll
	module DebugFilter

		def debug(obj, stdout=false)
			pretty = obj.pretty_inspect
			puts pretty if stdout
			pretty = pretty.gsub(/\=\>/, ': ')
			highlight = Jekyll::Tags::HighlightBlock.new('highlight', 'json', [
					pretty,
					"{% endhighlight %}"
			])
			pretty = highlight.render_pygments(pretty, true)
			pretty = highlight.add_code_tag(pretty)
			pretty = pretty.sub(/<div class="highlight">/, "<div class=\"highlight debug\" title=\"#{obj.class}\">")
			return pretty
		end

		def debug_text(obj, stdout=false)
			pretty = obj.pretty_inspect
			puts pretty if stdout
			pretty = pretty.gsub(/\=\>/, ': ')
			pretty = CGI.escape_html(pretty)
			pretty = "<pre class=\"debug\">#{obj.class}\n#{pretty}</pre>"
			return pretty
		end

	end # DebugFilter
end # Jekyll

Liquid::Template.register_filter(Jekyll::DebugFilter)
