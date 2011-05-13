require 'net/http'
require 'fileutils'

module Assetify
  class Asset
    include Helpers
    attr_accessor :type, :name, :url, :ns

    def initialize(type, name, url, ver = nil, params={})
      raise "NoType" unless type
      raise "NoName" unless name
      raise "NoURL" unless url
      @type, @name = type, name
      @ver = ver
      @url = @ver ? url.gsub(/{VERSION}/, @ver) : url
      @ns = params[:ns] || ""
      @pkg = params[:pkg]
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
      print "-> #{name}"
      # points = Thread.new { loop do; print "."; sleep 1; end }
      return print_result "Installed" if !force && check?
      @data ||= @pkg ? @pkg.get(url) : download
      write
      print_result :ok
    end


  end

end
