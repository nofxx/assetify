require 'libarchive'

module Assetify

  class Pkg
    include Helpers
    attr_accessor :name, :url

    PATH = "/tmp/"

    def initialize(name, url)
      @name = name
      @pkgname = url.split("/").last
      @url = url
    end

    def path
      File.join(PATH, name)
    end

    def fullpath
      File.join(path, @pkgname)
    end

    def get(file)
      unless File.exists? File.join(fullpath) #PATH, @pkgname)
        write get_data(url)
      end
      data = nil
      Archive.read_open_filename(fullpath) do |ar|
        while entry = ar.next_header
          if entry.pathname =~ /#{file}/
            data = ar.read_data
            return data
          end
        end
      end
      data
    end

  end

end
