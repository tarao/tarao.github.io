module Jekyll
  module UncapitalizeFilter
    def uncapitalize(input)
      input[0, 1].downcase + input[1..-1]
    end
  end
end

Liquid::Template.register_filter(Jekyll::UncapitalizeFilter)
