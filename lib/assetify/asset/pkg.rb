require 'libarchive'

module Assetify

  class Pkg
    include Helpers
    attr_accessor :name, :url

    PATH = "/tmp/"

    def initialize(name, url, opts={})
      @name = name
      @pkgname = url.split("/").last
      @url = url
    end

    def path
      File.join(PATH, name.to_s)
    end

    def fullpath
      File.join(path, @pkgname)
    end

    def read_from_pkg(regex = ".*")
      data = {}
      Archive.read_open_filename(fullpath) do |ar|
        while entry = ar.next_header
          if entry.pathname =~ /#{regex}/
            data.merge! entry.pathname => ar.read_data
           # return data
          end
        end
      end
      data
    end

    def get(file, force = false)
      # Download and write to tmp if force or doensnt exists
      write(get_data(url)) if force || !File.exists?(fullpath)
      # Better way when multiple are found....?
      read_from_pkg(file)
    end

    #
    # Used when pkgs doesn't provide a block, just dump it somewhere.
    #
    def unpack_all
      read_from_pkg.each do |file, data|
        fname, *dir = file =~ /\/$/ ? [nil, file] : file.split("/").reverse
        dir = File.join Opt[:vendor], dir.reverse.join("/")
        FileUtils.mkdir_p dir unless Dir.exists?(dir)
        next if file =~ /\/$/ # next if data.empty?
        File.open(Opt[:vendor] + "/#{file}", "w+") { |f| f.puts(data) }
      end
    end

  end

end
