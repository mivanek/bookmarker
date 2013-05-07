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

  def no_folder_bookmarks(folders)
    current_user.bookmarks.where('folder_id = ?', folders.where(name: "no_folder").first.id)
  end

  def no_folder
    current_user.folders.where(name: 'no_folder').first
  end

  def all_except_no_folder(folders)
    folders.where('name <> ?', 'no_folder')
  end

  def folder_array
    all_folders ||= []
    all_folders << ["None", no_folder.id]
    all_except_no_folder(current_user.folders).map { |folder| all_folders << [folder.name, folder.id] }
    all_folders
  end
end
