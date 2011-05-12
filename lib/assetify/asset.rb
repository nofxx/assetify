require 'net/http'

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
    end

    def filename
      fname = Opt[:newname] ? name : url.split("/").last
      fname += ".#{type}" unless fname =~ /\.#{type}$/
    end

    def fullpath
      path = Opt["#{type}path".to_sym]
      File.join(path, filename) #Dir.pwd,
    end

    def check?
      File.exists? fullpath
    end

    def write
      #puts "Writing to #{fullpath}"
      File.open(fullpath, "w") { |f| f.puts(@data) }
    end

    def download
      uri = URI.parse url
      Net::HTTP.start(uri.host) do |http|
        @data = http.get(uri.path)
      end
    end

    def install!(force = false)
      print "Installing #{name}..."
      return puts "Installed" if !force && check?
      download unless @data
      write
      puts "DONE"
    end

  end



end
