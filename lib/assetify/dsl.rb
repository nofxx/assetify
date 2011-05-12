module Assetify


  class DSL

    class << self
      def group name, &block
        ns = name
        def st.method_missing method, name, url
          Asset.new method.to_sym, ns + name, url
        end
        st.instance_exec(&block)
      end

      def method_missing(method, name, url, ver=nil, params={})
        Asset.new method.to_sym, name, url, ver
      end
    end
  end


end
