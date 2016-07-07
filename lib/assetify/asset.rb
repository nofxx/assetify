require 'net/http'
require 'fileutils'
require 'assetify/asset/pkg'
require 'assetify/asset/pathfix'

module Assetify
  class Asset
    include Helpers
    attr_accessor :type, :name, :url, :ns, :pkg, :ver, :ext, :as

    def initialize(type, name, url, ver = nil, params = {})
      raise 'NoType' unless type
      raise 'NoName' unless name
      raise 'NoURL' unless url
      @type = type
      @name = name.to_s
      @url = (@ver = ver) ? url.gsub(/{VERSION}/, @ver) : url
      if @name =~ /\./
        @name, @ext = name.split('.')
      else
        @ext = @type == :img ? find_ext_for(url) : @type
      end

      @pkg = params[:pkg]
      @as = params[:as]
      @ns = params[:ns]
      @to = params[:to] || ''
    end

    def filename
      return @filename if @filename
      @filename = "#{name}.#{ext}"
      @filename += ".#{as}" if as
      @filename
    end

    def find_ext_for(file)
      file.split('.').last[0, 3]
    end

    #
    # Find correct path to put me
    #
    def find_path_for(txt)
      case txt
      when /js/  then :javascripts
      when /css|style/ then :stylesheets
      else :images
      end
    end

    def path
      args = if @to.empty?
               tpath = Opt[find_path_for(type)]
               raise "Don`t know where to put #{type} files..." unless tpath
               [tpath, @ns ? @ns.to_s : '']
             else
               [Dir.pwd, @to]
      end
      @path = File.join(args)
    end

    def fullpath
      @fullpath ||= File.join(path, filename)
    end

    def file_exists?
      File.exist? fullpath
    end

    def data
      return @data if @data
      # Get data, from a pkg or download directly
      @data = @pkg ? @pkg.get(url, :force).values.first : get_data(url)

      # Compile/fix paths if asked to
      @data = Pathfix.new(@data, @as, @ns).fix if @as

      @data
    end

    def read_data
      @data = File.read(fullpath)
    end

    #
    # Prints info about the asset (TODO: move this to cli...)
    #
    def header
      "-> #{name}.#{type}"
    end

    #
    # Asset version
    #
    def ver
      return nil unless @data
      @ver ||= find_version(@data)
    end

    def print_version
      return '' unless ver
      # chop to only first 10 chars if it's big hash
      ver_str = ver.size > 10 ? ver[0..10] : ver[0]
      "v#{ver_str}"
    end

    #
    # Write down asset to disk
    #
    def install!(_force = false)
      write data
    rescue => e
      LINE.f :FAIL, :red
      p "Fail: #{e} #{e.backtrace}"
    end

    class << self
      #
      # Simple cache store, read Assetfile and dump it here to use.
      #
      def all
        @all ||= Assetfile.read
      end

      def filter(params)
        all.select do |a|
          blob = "#{a.name}#{a.pkg.name if a.pkg}"
          blob.include? params
        end
      end
    end
  end
end
