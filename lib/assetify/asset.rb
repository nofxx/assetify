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
      @url = (@ver = ver) ? url.gsub(/{VERSION}/, @ver) : url
      @ns = params[:ns] || ""
      @to = params[:to] || ""
      @pkg = params[:pkg]
    end

    def filename
      return @filename if @filename
      @filename = Opt[:newname] ? name : url.split("/").last
      @filename += ".#{type}" unless @filename =~ /\.#{type}$/
      @filename
    end

    def path
      args = if @to.empty?
        tpath = Opt["#{type}path".to_sym]
        raise "Don`t know where to put #{type} files..." unless tpath
        [tpath,  @ns ? @ns.to_s : ""]
      else
        [Dir.pwd, @to]
      end
      @path = File.join(args)
    end

    def fullpath
      @fullpath ||= File.join(path, filename)
    end

    def check?
      File.exists? fullpath
    end

    def install!(force = false)
      LINE.p "-> #{name}.#{type}"
      return LINE.f "Installed" if !force && check?
      begin
        points = Thread.new { loop do; LINE.p "."; sleep 1; end }
        @data ||= @pkg ? @pkg.get(url) : get_data(url)
        version = find_version @data
        write @data
        LINE.f version ? "v#{version[0]} ok" : "ok"
      rescue => e
        LINE.f :FAIL, :red
        p "Fail: #{e}"
      ensure
        points.kill
      end

    end

  end

end
