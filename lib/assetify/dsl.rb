module Assetify

  class DSL

    def group name, &block
      @ns = name
      # def st.method_missing method#, name, url
      #   p method
      #  # Asset.new method.to_sym, ns + name, url
      # end
      instance_exec(&block)
    end

    def assets
      @assets
    end

    def method_missing(method, name, url, ver=nil, params={})
      (@assets ||= []) << Asset.new(method.to_sym, name, url, ver, params.merge({ :ns => @ns}))
    end

    class << self

      def parse(io)
        new.instance_eval(io) #.assets
      end

    end

  end

end
