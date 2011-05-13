require 'libarchive'

module Assetify

  class Pkg
    include Helpers
    attr_accessor :name, :url

    PATH = "/tmp/"

    def initialize(name, url)
      @name = name
      @pkgname = url.split("/").last
      @url = URI.parse(url)
    end

    def path
      File.join(PATH, name)
    end

    def fullpath
      File.join(path, @pkgname)
    end

    def get(file)
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

    def ensure
      download unless File.exists? File.join(PATH, @pkgname)
      unpack
    end

  end

end
