# coding: utf-8

class String
  def has_ja_char?
    self =~ /(?:\p{Hiragana}|\p{Katakana}|[一-龠々])/
  end
end

module Jekyll
  module AuthorsFilter
    def authors(input)
      input = [input] unless input.is_a?(Array)
      input = input.map{|item| "<span class=\"author\">#{item}</span>"}

      if input.size <= 1
        input.join('')
      elsif input.any?{|item| item.has_ja_char?}
        input.join(', ')
      else
        rest, last = [input[0..-2], input[-1]]
        rest = rest.map{|item| item + ', '} if rest.size >= 2
        [ rest.join(''), last ].join(' and ')
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::AuthorsFilter)
