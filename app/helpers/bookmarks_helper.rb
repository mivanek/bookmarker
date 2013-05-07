module BookmarksHelper

  def url_checker(url)
    return "" if url.blank?
    if protocol.include? url
      url
    else
      "http://#{url}"
    end
  end

  def protocol
    %w{http:// https:// ftp://}
  end
end
