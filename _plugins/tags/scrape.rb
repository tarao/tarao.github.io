require 'net/http'
require 'uri'
require 'nokogiri'
require 'time'

module Jekyll
  class Scraper < Liquid::Block
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

    def attribute(context, key)
      value = @attributes[key]
      value = Liquid::VariableLookup.new(value).evaluate(context) if value.respond_to?(:scan)
      value || @attributes[key]
    end

    def render(context)
      url = attribute(context, 'url')

      document = cache.getset(url) do
        source = Net::HTTP.get(URI.parse(url))
        Nokogiri::HTML(source)
      end

      item_selector = attribute(context, 'item')
      title_selector = attribute(context, 'title')
      link_selector = attribute(context, 'link')
      date_selector = attribute(context, 'date')

      items = document.search(item_selector) || []

      length = items.length
      result = []

      context.stack do
        items.each_with_index do |item, index|
          context['item'] = {
            'title' => item.at(title_selector).content,
            'link'  => item.at(link_selector).attribute('href').content,
            'date'  => Time.parse(item.at(date_selector).content),
          }

          context['forloop'] = {
            'name'    => 'githubrepos',
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

Liquid::Template.register_tag('scrape', Jekyll::Scraper)
