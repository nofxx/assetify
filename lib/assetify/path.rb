module Path
  class Findr

    def initialize chunk, ns = nil
      @chunk = chunk
      @ns = ns
      matches
    end

    def comm src
      "assets_path(\"#{@ns}#{src}\", image)"
    end

    def matches
      @images = @chunk.scan(/url\((.*)\)/).flatten
    end

    def images
      @images
    end

    def fixed
      sprocketized = @chunk
      @images.each do |asset|
        sprocketized[asset] = comm asset.split("/").last #gsub(/\.|\//, "")
      end
      sprocketized
    end

  end

end
