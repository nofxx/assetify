require "net/http"
require "fileutils"
require "assetify/asset/pkg"
require "assetify/asset/pathfix"

module Assetify

  class Asset
    include Helpers
    attr_accessor :type, :name, :url, :ns, :pkg, :ver, :ext

    def initialize(type, name, url, ver = nil, params={})
      raise "NoType" unless type
      raise "NoName" unless name
      raise "NoURL" unless url
      @type, @name = type, name.to_s
      @url = (@ver = ver) ? url.gsub(/{VERSION}/, @ver) : url
      if @name =~ /\./
        @name, @ext = name.split(".")
      else
        @ext = @type == :img ? find_ext_for(url) : @type
      end

      @pkg = params[:pkg]
      @ns = params[:ns] || ""
      @to = params[:to] || ""
    end

    def filename
      return @filename if @filename
      @filename = "#{name}.#{ext}"
    end

    def find_path_for txt
      case txt
      when /js/  then :javascripts
      when /css|style/ then :stylesheets
      else :images
      end
    end

    def find_ext_for file
      file.split(".").last[0,3]
    end

    def path
      args = if @to.empty?
        tpath = Opt[find_path_for(type)]
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

    def file_exists?
      File.exists? fullpath
    end

    def print_version
      return "" unless ver
      ver_str = ver.size > 10 ? ver[0..10] : ver[0]
      "v#{ver_str} "
    end

    def data
      # Get data, from a pkg or download directly
      @data ||= @pkg ? @pkg.get(url, :force).values.first : get_data(url)
    end

    def ver
      return nil unless @data
      @ver ||= find_version(@data)
    end

    def header
      LINE.p "-> #{name}.#{type}"
    end

    def check!
      header
      if  file_exists? # Return if file is on path
        @data = File.read(fullpath)
        LINE.f "#{print_version}Installed"
      else
        LINE.f "Not Found", :red
      end
    end

    def install!(force = false)
      header
      if !force && file_exists? # Return if file is on path
        @data = File.read(fullpath)
        return LINE.f "#{print_version}Installed"
      end
      begin
        # Creates a thread to insert dots while downloading
        points = Thread.new { loop do; LINE.p "."; sleep 1; end }

        write data
        LINE.f "#{print_version}ok"
      rescue => e
        LINE.f :FAIL, :red
        p "Fail: #{e} #{e.backtrace}"
      ensure
        points.kill
      end

    end

    class << self
      # Simple cache for Jsfile
      def self.set_all v
        @all = v
      end
      def self.all
        @all
      end
    end

  end

end
