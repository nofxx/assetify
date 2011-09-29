module Path
  class Findr

    def initialize chunk, ns = nil
      @chunk = chunk
      @ns = ns
      matches
    end

    def sass?
      true
    end

    def replace src
      if sass?
        "image-url('#{@ns}#{src}')"
      else
        "url('<%= image_path(#{@ns}#{src}) %>)"
      end
    end

    def matches
      @images = @chunk.scan(/url\((.*)\)/).flatten
    end

    def images
      @images
    end

    def fixed
      sprocketized = @chunk
      @images.each do |uri|
        sprocketized["url(#{uri})"] = replace uri.split("/").last
        #gsub(/\.|\//, "")
      end
      sprocketized
    end

  end

end
