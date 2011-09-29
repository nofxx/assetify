require 'digest/md5'

module Assetify
  module Helpers

    #
    # Detects numerical software version from text.
    #
    def find_version(txt)
      return unless txt
      txt.binary? ? find_version_from_bin(txt) : find_version_from_txt(txt)
    end

    private

    def find_version_from_txt blob
      version = blob.match(/(?:(\d+)\.)?(?:(\d+)\.)?(\d+)?\.?(\d+)/)
      # If matches a dot, it`s text. Otherwise make it number.
      v = version.to_a.reject(&:nil?).map { |d| d =~ /\./ ? d : d.to_i }
      v.empty? || 0 == v[0] ? nil : v
    end

    def find_version_from_bin blob
      Digest::MD5.hexdigest blob
    end

    def download url_str, limit = 10
      raise ArgumentError, 'HTTP redirect too deep' if limit == 0
      uri = URI.parse url_str
      # # response = ""
      http = Net::HTTP.start(uri.host, :use_ssl => url_str =~ /https/)# do |http|
      response = http.get(uri.path.empty? ? "/" : uri.path)
      # # end
      # response = Net::HTTP.get_response(URI.parse(url_str) )# ,:use_ssl => url_str =~ /https/ )
      case response
      when Net::HTTPSuccess     then @data = response
      when Net::HTTPRedirection then download(redirect_url(response), limit - 1)
      else
        puts "response code: #{response.code}!"
        response.error!
      end
    end

    def get_data(str)
      @data = if str =~ /http/
        download(str).body
      else
        File.open(str)
      end
    end

    def write(binary)
      FileUtils.mkdir_p path unless  Dir.exists?(path)
      File.open(fullpath, "w") { |f| f.puts(binary) }
    end

    def redirect_url response
      if response['location'].nil?
        response.body.match(/<a href=\"([^>]+)\">/i)[1]
      else
        response['location']
      end
    end

  end
end
