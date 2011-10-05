module Assetify
  class Pathfix

    def initialize chunk, as = :erb, ns = nil
      @chunk, @as, @ns = chunk, as, ns
      @images = scan_images
    end

    def images
      @images
    end

    def scan_images
      @chunk.scan(/url\(([a-zA-Z0-9\/\_\-\.]*\.\w+)\)/xo).flatten
    end

    def replace src
      fpath = @ns ? "#{@ns}/#{src}" : src
      if @as == :erb
        "url('<%= image_path('#{fpath}') %>')"
      else
        "image-url('#{fpath}')"
      end
    end

    def fix
      @images.each do |path|
        @chunk["url(#{path})"] = replace path.split("/").last
      end
      @as != :erb ? tmpl_chunk : @chunk
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
