module Jekyll
  module StripTitleFilter
    def strip_title(input, title)
      sep = '\s*[^a-zA-Z0-9]\s*'
      escaped = Regexp.escape(title)
      regex = Regexp.new("(?:^#{escaped + sep}|#{sep + escaped}$)")
      input.gsub(regex, '')
    end
  end
end

Liquid::Template.register_filter(Jekyll::StripTitleFilter)
