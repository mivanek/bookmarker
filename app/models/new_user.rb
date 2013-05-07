#require 'sessions_helper'

#class NewUser
  #include SessionsHelper

  #def default_websites
    #%w(http://www.ebay.com http://www.amazon.com http://www.google.com
       #http://www.wikipedia.org http://www.facebook.com http://www.youtube.com)
  #end

  #def populate
    #default_websites.each do |website|
      #title, description, url = parser.new(website).parse
      #current_user.bookmark.create(title: title, description: description, url: url)
    #end
  #end

  #private

    #def parser
      #ElementsParser
    #end
#end
