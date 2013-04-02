module BookmarksHelper

  def url_checker(url)
    return "" if url.blank?
    if url.include? "http://"
      url
    else
      "http://#{url}"
    end
  end
end
