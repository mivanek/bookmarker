require 'nokogiri'
require 'open-uri'
require 'sanitize'

class ElementsParser

  def initialize(url)
    @url = url
  end

  def parse
    get_site
    get_title
    get_description

    return [title, description, url]
  end

  private

    def get_description
      description = site.css("meta[name='description']").first
      @description = description['content'].strip rescue nil
    end

    def get_site
      @site = Nokogiri::HTML(open(url, allow_redirections: :all))
    end

    def get_title
      @title = Sanitize.clean(site.css('title').text).strip
    end

    def url
      @url
    end

    def site
      @site
    end

    def title
      @title
    end

    def description
      @description
    end
end
