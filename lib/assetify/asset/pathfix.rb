module Assetify
  class Pathfix

    def initialize chunk, ns = nil
      @chunk = chunk
      @ns = ns
      matches
    end

    def sass?
      true
    end



    def matches
      @images = @chunk.scan(/url\((.*)\)/).flatten
    end

    def images
      @images
    end

    def replace src, tmpl
      if tmpl == :erb
        "url('<%= image_path(#{@ns}#{src}) %>')"
      else
        "image-url('#{@ns}#{src}')"
      end
    end

    def fix tmpl
      unless tmpl == :erb
        as tmpl
      end
      sprocketized = @chunk
      @images.each do |uri|
        sprocketized["url(#{uri})"] = replace uri.split("/").last, tmpl
        #gsub(/\.|\//, "")
      end
      sprocketized
    end

    def as tmpl = :sass
      begin
        require 'sass/css'
        @chunk = Sass::CSS.new(@chunk).render(tmpl)
      rescue Sass::SyntaxError => e
        @error = e
      end
    end

    def as_sass
      fix :sass
    end

    def as_scss
      fix :scss
    end

    def as_erb
      fix :erb
    end

  end

end
