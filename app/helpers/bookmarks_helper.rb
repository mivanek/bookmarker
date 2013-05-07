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

  def no_folder
    @bookmarks.where('folder_id = ?', @folders.where(name: "no_folder").first.id)
  end

  def all_except_no_folder
    @folders.where('name <> ?', 'no_folder')
  end
end
