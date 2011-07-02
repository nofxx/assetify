module Assetify

  class DSL
    attr_reader :assets

    def set_namespace(name)
      @ns = @ns.nil? ? name : "#{@ns}/#{name}"
    end

    def pkg name, url, opts = {}, &block
      @pkg = Pkg.new name, url
      if block_given?
        set_namespace name unless opts[:shallow]
        instance_exec &block
        @ns = @pkg = nil
      else
        @pkg.unpack_to_vendor
      end
      assets
    end

    def group name, &block
      set_namespace name
      instance_exec &block
      @ns = nil
      assets
    end

    def dir regex, to
      to = to[:to]
      if @pkg
        @pkg.get(regex).each do |path, data|
          next if path =~ /\/$/ # dont let dirs get in... ugly
          ext, *name = path.split(".").reverse
          name = name.reverse.join(".").split("/").last
          (@assets ||= []) << Asset.new(ext, name, path, nil, {
                                        :pkg => @pkg,
                                          :to => to})# h.split(".").last,                                        )
        end
      end
    end

    # Create assets path setters
    Assetify::ASSETS.each do |asset|
      define_method asset do |path|
        Opt[asset] = path
      end
    end

    #
    # js "foo", "http://foo.com"
    # js "foo", "http://foo.com", :to => "/other/place"
    #
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
