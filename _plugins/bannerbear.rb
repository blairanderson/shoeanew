require 'openssl'
require 'date'
require 'fileutils'
require 'active_support'
require 'active_support/core_ext'
BANNERBEAR_SIGNED_URL = "https://on-demand.bannerbear.com/signedurl/qamMwPXe2vwe2KjLgQ/image.jpg"

module Jekyll
  module BannerbearFilter
    def bannerbear_url(image_url, avatar_url, author_name, date, title)
      #api_key: your project API key - keep this safe and non-public
      api_key = ENV["BANNERBEAR_KEY"]
      # api_key = "nibwwxmBWs0gXSvr60k2JAtt"

      if api_key.nil? || api_key.empty?
        puts "ENV['BANNERBEAR_KEY'] is blank. returning image_url"
        return image_url
      end

      #base: this signed url base
      base = BANNERBEAR_SIGNED_URL

      # photo, avatar, name, date, title
      options = [
        {"name" => "photo","image_url" => image_url},
        {"name" => "avatar","image_url" => avatar_url},
        {"name" => "name","text" => author_name},
        {"name" => "date","text" => date},
        {"name" => "title","text" => title}
      ]

      #query: the query string of modifications you want to generate
      query = "?#{options.to_query("m")}"
      #query: the query string of modifications you want to generate
      # query = "?m[][name]=backround&m[][image_url]=#{image_url}&m[][name]=pre_title&m[][text]=#{CGI.escape(pre_title)}&m[][name]=title&m[][text]=#{CGI.escape(title)}"

      #calculate the signature
      signature = OpenSSL::HMAC.hexdigest("SHA256", api_key, base+query)

      #append the signature
      return base + query + "&s=" + signature
    end
  end
end

Liquid::Template.register_filter(Jekyll::BannerbearFilter)
