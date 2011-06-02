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

    def read_from_pkg(regex)
      data = nil
      Archive.read_open_filename(fullpath) do |ar|
        while entry = ar.next_header
          if entry.pathname =~ /#{regex}/
            data = ar.read_data
            return data
          end
        end
      end
      data
    end

    def get(file, force = false)
      # Download and write to tmp if force or doensnt exists
      write(get_data(url)) if force || !File.exists?(File.join(fullpath))
      read_from_pkg file
    end

  end

end
