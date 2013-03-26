require 'nokogiri'
require 'open-uri'
require 'sanitize'

module ElementsParser

  def get_title(url)
    site = Nokogiri::HTML(open(url))
    Sanitize.clean(site.css('title').text).strip
  end

  def get_description(url)
    site = Nokogiri::HTML(open(url))
    meta_desc = site.css("meta[name='description']").first
    meta_desc['content'].strip
  end
end
