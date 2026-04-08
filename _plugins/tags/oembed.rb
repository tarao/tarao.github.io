##
# OEmbed Liquid Tag for Jekyll
#   - requires https://github.com/judofyr/ruby-oembed/
#
# Copyright 2011 Tammo van Lessen
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#
# Modified by @tarao.
# Original: https://gist.github.com/vanto/1455726
##
require 'oembed'
require 'uri'

# register all default OEmbed providers
::OEmbed::Providers.register_all()
# since register_all does not register all default providers, we need to do this here. See https://github.com/judofyr/ruby-oembed/issues/18
::OEmbed::Providers.register(::OEmbed::Providers::Slideshare, ::OEmbed::Providers::Yfrog, ::OEmbed::Providers::MlgTv)
::OEmbed::Providers.register_fallback(::OEmbed::ProviderDiscovery, ::OEmbed::Providers::Embedly, ::OEmbed::Providers::OohEmbed)

module Jekyll
  class OEmbed < Liquid::Tag

    def initialize(tag_name, text, tokens)
       super
       @text = text
    end

    def cache
      @@cache ||= Jekyll::Cache.new(self.class.name)
    end

    def render(context)
      # pipe param through liquid to make additional replacements possible
      url = Liquid::Template.parse(@text).render context
      url.strip!

      result = cache.getset(url) do
        begin
          # oembed look up
          ::OEmbed::Providers.get(url)
        rescue ::OEmbed::NotFound => e
          false
        end
      end

      if result
        # Odd: slideshare uses provider-name instead of provider_name
        provider = result.fields['provider_name'] || result.fields['provider-name'] || 'unknown'

        "<div class=\"embed #{result.type} #{provider}\">#{result.html}</div>"
      else
        ''
      end
    end
  end
end

Liquid::Template.register_tag('oembed', Jekyll::OEmbed)
