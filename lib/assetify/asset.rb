require 'net/http'
require 'fileutils'

module Assetify
  class Asset
    attr_accessor :type, :name, :url

    def initialize(type, name, url, ver = nil, params={})
      raise "NoType" unless type
      raise "NoName" unless name
      raise "NoURL" unless url
      @type, @name = type, name
      @ver = ver
      @url = @ver ? url.gsub(/{VERSION}/, @ver) : url
      @ns = params[:ns] || ""
    end

    def filename
      return @filename if @filename
      @filename = Opt[:newname] ? name : url.split("/").last
      @filename += ".#{type}" unless @filename =~ /\.#{type}$/
      @filename
    end

    def path
      @path = File.join(Opt["#{type}path".to_sym],  @ns ? @ns.to_s : "")
    end

    def fullpath
      @fullpath ||= File.join(path, filename)
    end

    def check?
      File.exists? fullpath
    end

    def install!(force = false)
      print "Installing #{name}..."
      return puts "Installed" if !force && check?
      download unless @data
      write
      puts "DONE"
    end

    private

    def download
      uri = URI.parse url
      Net::HTTP.start(uri.host) do |http|
        @data = http.get(uri.path)
      end
    end

    def write
      FileUtils.mkdir_p path unless Dir.exists? path
      File.open(fullpath, "w") { |f| f.puts(@data) }
    end

  end

end
