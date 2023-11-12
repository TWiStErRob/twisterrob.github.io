# A simple way to inspect liquid template variables.
# Based on: https://github.com/plusjade/jekyll-bootstrap/blob/master/_plugins/debug.rb
# The filters below can be used anywhere liquid syntax is parsed (templates, includes, posts/pages/collections)

require 'pp' # obj.pretty_inspect
require 'cgi' # CGI.escape_html
require 'json' # JSON.generate

# noinspection RubyUnnecessaryReturnStatement
module DebugFilter
	# Returns a highlighted HTML code block displaying the received object.
	# Example usages:
	# * <tt>{{ site.pages | debug }}</tt>
	# * <tt>{{ site.pages | debug: 'pages' }}</tt>
	def debug(obj, label = nil)
		pretty = JSON.generate(
				obj,
				# Based on PRETTY_STATE_PROTOTYPE from ruby/json/common.rb JSON::generator=
				:indent => "\t",
				:space => ' ',
				:space_before => '',
				:object_nl => "\n",
				:array_nl => "\n",
				# Based on FAST_STATE_PROTOTYPE from ruby/json/common.rb JSON::generator=
				:max_nesting => false,
				# Hidden tricks from ruby/gems/json-1.8.3/ext/json/ext/generator/generator.c cState_to_h
				:quirks_mode => true,
				:ascii_only => false,
				:allow_nan => true,
		)
		#File.open('debug.json', 'w') { |file| file.write(pretty) }
		highlight = Jekyll::Tags::HighlightBlock.parse('highlight', 'json', [pretty, '{% endhighlight %}'], [])
		pretty = highlight.render_pygments(pretty, true)
		pretty = highlight.add_code_tag(pretty)
		pretty = pretty.sub(/<figure class="highlight">/, "<figure class=\"highlight debug\" title=\"#{prefix(obj, label)}\">")
		#File.open('debug.json.html', 'w') { |file| file.write(pretty) }
		pretty = reindent_json_html(pretty)
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

	def reindent_json_html(pretty)
		indent = "\t"
		indent_regex = "(?:#{indent})" # non-capturing group so it can be repeated safely
		array_open = '<span class="p">[</span>'
		array_middle = '<span class="p">,</span>'
		array_close = '<span class="p">]</span>'
		array_close_middle = '<span class="p">],</span>'
		object_open = '<span class="p">{</span>'
		object_close = '<span class="p">}</span>'
		object_close_middle = '<span class="p">},</span>'
		string_open = '<span class="s2">&quot;'
		string_close = '&quot;</span>'
		# Fix `},\n{` -> `}, {`
		pretty = pretty.gsub(/^(#{indent_regex}*)#{rq(object_close_middle)}\n\1#{rq(object_open)}/,
				"\\1#{object_close_middle} #{object_open}")
		# Fix `[\n"` -> `[ "`
		pretty = pretty.gsub(/#{rq(array_open)}\n(#{indent_regex}*)#{rq(string_open)}/,
				"#{array_open} #{string_open}")
		# Fix `,\n"` -> `, "`
		pretty = pretty.gsub(/#{rq(array_middle)}\n(#{indent_regex}*)#{rq(string_open)}/,
				"#{array_middle} #{string_open}")
		# Fix `"\n]` -> `" ]`
		pretty = pretty.gsub(/#{rq(string_close)}\n(#{indent_regex}*)#{rq(array_close)}/,
				"#{string_close} #{array_close}")
		# Fix `"\n],` -> `" ],`
		pretty = pretty.gsub(/#{rq(string_close)}\n(#{indent_regex}*)#{rq(array_close_middle)}/,
				"#{string_close} #{array_close_middle}")
		return pretty
	end

	def prefix(obj, label)
		clazz = "(#{cls(obj)})" if obj
		label = "#{label}: " if label
		# noinspection RubyScope
		return "#{label}#{clazz}" # clazz is nil if obj is nil
	end

	def cls(obj)
		if obj.class == Array
			return "#{obj.class} of #{cls(obj[0])}"
		else
			return "#{obj.class}"
		end
	end

	def rq(str)
		return Regexp.quote(str)
	end
end # DebugFilter

Liquid::Template.register_filter(DebugFilter)

# Need to overwrite the debugging methods, because the original uses a strange format or too verbose at times.
# For example Document and Page has `content` as its default to_s, which may be extremely long.

# noinspection RubyUnnecessaryReturnStatement
module JekyllRedirectFrom
# TOFIX gems/jekyll-redirect-from-0.12.1/lib/jekyll-redirect-from/generator.rb:27:in `block in generate_redirect_from': undefined method `redirect_from' for JekyllRedirectFrom::RedirectPage:Class (NoMethodError)
#	class RedirectPage
#		def to_s
#			return "<#{self.class} #{File.join(self.dir, self.name)}>"
#		end
#	end
end

# noinspection RubyUnnecessaryReturnStatement
module Jekyll
	class Document
		def to_s
			return "<#{self.class} of #{self.collection.label}: #{self.id}>"
		end
	end
	class Collection
		def to_s
			return "<#{self.class} #{self.label}>"
		end
	end
	class Page
		def to_s
			"<#{self.class} #{self.path}>"
		end
	end
	class StaticFile
		def to_s
			return "<#{self.class} #{self.relative_path}>"
		end
	end

	# TODO site.static_files: "#<Jekyll::StaticFile:0x00000005b9aeb0>"
	module Drops
		# https://stackoverflow.com/a/4471202/253468 > Method Wrapping is used to override behavior
		class DocumentDrop
			self_hash_for_json = instance_method(:hash_for_json)
			define_method(:hash_for_json) do |state = nil|
				# Fake state to satisfy DocumentDrop::hash_for_json method's argument
				class DuckState
					def depth
						10
					end
				end
				# make sure prev/next are always collapsed by faking a state that's more than 2 deep
				self_hash_for_json.bind(self).(DuckState.new)
			end
			# collapse docs a little differently (no hash structure, just a string saying what it is)
			def collapse_document(doc)
				return doc.to_s
			end

			# shorten textual hash values to overshadow important values in the hash
			self_to_h = instance_method(:to_h)
			truncatewords = Liquid::StandardFilters.instance_method(:truncatewords).bind(self)
			define_method(:to_h) do
				self_to_h.bind(self).().tap do |hash|
					hash['content'] = truncatewords.call(hash['content']) if hash['content']
					hash['excerpt'] = truncatewords.call(hash['excerpt']) if hash['excerpt']
				end
			end
		end
	end
end
