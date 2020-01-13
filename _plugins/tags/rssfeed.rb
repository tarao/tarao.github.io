require 'net/http'
require 'uri'
require 'rss'

module Jekyll
  class RssFeedReader < Liquid::Block
    def initialize(tag_name, markup, parse_context)
      super

      @attributes = {}
      markup.scan(Liquid::TagAttributes) do |key, value|
        @attributes[key] = value
      end if markup
    end

    def cache
      @@cache ||= Jekyll::Cache.new(self.class.name)
    end

    def render(context)
      url = @attributes['url']
      url = Liquid::VariableLookup.new(url).evaluate(context) if url.respond_to?(:scan)
      url ||= @attributes['url']

      rss = cache.getset(url) do
        source = Net::HTTP.get(URI.parse(url))
        RSS::Parser.parse(source)
      end

      length = rss.items.length
      result = []

      context.stack do
        rss.items.each_with_index do |item, index|
          context['item'] = {
            'title'       => item.title,
            'link'        => item.link,
            'description' => item.description,
            'date'        => item.date,
          }

          context['forloop'] = {
            'name'    => 'rssfeed',
            'length'  => length,
            'index'   => index + 1,
            'index0'  => index,
            'rindex'  => length - index,
            'rindex0' => length - index - 1,
            'first'   => (index == 0),
            'last'    => (index == length - 1),
          }

          result << nodelist.map do |n|
            if n.respond_to? :render
              n.render(context)
            else
              n
            end
          end.join('')
        end
      end

      result
    end
  end
end

Liquid::Template.register_tag('rssfeed', Jekyll::RssFeedReader)
