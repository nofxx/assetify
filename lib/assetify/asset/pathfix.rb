module Assetify
  class Pathfix

    def initialize chunk, as = :erb
      @chunk, @as = chunk, as
      @images = @chunk.scan(/url\((.*)\)/).flatten
    end

    def images
      @images
    end

    def replace src
      if @as == :erb
        "url('<%= image_path(#{@ns}#{src}) %>')"
      else
        "image-url('#{@ns}#{src}')"
      end
    end

    def fix
      chunk = @as != :erb ? tmpl_chunk : @chunk
      @images.each do |uri|
        chunk["url(#{uri})"] = replace uri.split("/").last
      end
      chunk
    end

    def tmpl_chunk
      begin
        require 'sass/css'
        Sass::CSS.new(@chunk).render(@as)
      rescue Sass::SyntaxError => e
        @error = e
      end
    end

  end

end
