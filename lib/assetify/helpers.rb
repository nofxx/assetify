require 'digest/md5'

module Assetify
  module Helpers

    #
    # Detects numerical software version from text.
    #
    def find_version(txt)
      return unless txt
      if txt.binary?
        find_version_from_bin(txt)
      else
        v = find_version_from_txt(txt)
        v && v[0] =~ /(\d+)\.(\d+).*/ ? v :  find_version_from_bin(txt)
      end
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

    #
    # Downloads assets
    #
    def download url_str, limit = 10
      raise ArgumentError, 'HTTP redirect too deep' if limit == 0
      uri = URI.parse url_str
      http = Net::HTTP.start(uri.host, :use_ssl => url_str =~ /https/)# do |http|
      response = http.get(uri.path.empty? ? "/" : uri.path)

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

    def write binary
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
