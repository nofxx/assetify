module Assetify

  class DSL

    def pkg name, url, &block
      @pkg = Pkg.new name, url
      @ns = name
      instance_exec(&block)
      @ns = nil
      assets
    end

    def group name, &block
      @ns = name
      instance_exec(&block)
      @ns = nil
      assets
    end

    def assets
      @assets
    end

    def method_missing method, name, uri, *params
      params, ver = params.partition { |param| param.is_a?(Hash) }
      opts = {:ns => @ns, :pkg => @pkg}
      params.each { |hsh| opts.merge! hsh }
      ver = ver[0]
      (@assets ||= []) << Asset.new(method.to_sym, name, uri, ver, opts)
    end

    class << self

      def parse io
        new.instance_eval(io) #.assets
      end

    end

  end

end
