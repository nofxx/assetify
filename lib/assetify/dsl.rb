module Assetify
  #
  # Nice Assetfile reader
  #
  class DSL
    attr_reader :assets

    #
    # Makes a pkg, a gz/tar/zip asset/
    #
    # pkg :foo, "http://to.tgz" do
    # end
    #
    def pkg(name, url, opts = {}, &block)
      @pkg = Pkg.new name, url
      if block_given?
        use_namespace(name) unless opts[:shallow]
        instance_exec(&block)
      else
        @pkg.unpack_all
      end
      assets
    ensure
      @ns = @pkg = nil
    end

    #
    # Makes a group, a namespace for the assets.
    #
    # group :foo do
    # end
    #
    def group(name, &block)
      use_namespace(name)
      instance_exec(&block)
      @ns = nil
      assets
    ensure
      @ns = nil
    end

    #
    # Makes assets out of the entire directory
    #
    # pkg :foo do
    #   dir "images/*"
    #   dir "images/*jpg"
    # end
    #
    def dir(regex, params = {})
      to = params[:to]
      if @pkg
        @pkg.get(regex).each do |path, _data|
          next if path =~ %r{/$} # dont let dirs get in... ugly
          ext, *name = path.split('.').reverse
          name = name.reverse.join('.').split('/').last
          create_asset(ext, name, path, nil, to: to)
        end
      end
    end

    #
    # Global command, detects the filetype
    #
    #    a "jquery", "http://...jquery.js"
    #
    def a(name, url, *_params)
      extension = url.split('.').last
      parse_method extension, name, url
    end
    alias asset a

    #
    # Filter/validate DSL to parse
    #
    def method_missing(method, name = nil, uri = nil, *params)
      if name && uri
        parse_method method, name, uri, params
      else
        raise SyntaxError, "Syntax Error on Assetfile. `#{method} :#{name}`"
      end
    end

    #
    # Creates Assetfile assets path setters
    #
    # javascript "new/path"
    # ...
    Assetify::ASSETS.each do |asset|
      define_method asset do |path|
        Opt[asset] = path
      end
    end

    #
    # DSL.parse()
    #
    def self.parse(chunk)
      # puts "Assetify - Error Parsing 'Assetfile'."
      # Instance eval with 2nd, 3rd args to the rescue
      new.instance_eval(chunk, 'Assetfile', 1)
    end

    private

    #
    # Parse the DSL dynamic extensions
    #
    # js "foo", "http://foo.com"
    # js "foo", "http://foo.com", :to => "/other/place"
    #
    def parse_method(method, name, uri, params = [])
      params, ver = params.partition { |param| param.is_a?(Hash) }
      opts = {}
      params.each { |hsh| opts.merge! hsh }
      ver = ver[0]
      create_asset(method.to_sym, name, uri, ver, opts)
    end

    #
    # Helper to create asset with correct options
    #
    def create_asset(ext, name, path, ver, opts = {})
      opts[:pkg] = @pkg
      opts[:ns] = @ns
      @assets ||= []
      @assets << Asset.new(ext, name, path, ver, opts)
    end

    def use_namespace(name)
      @ns = @ns.nil? ? name : "#{@ns}/#{name}"
    end
  end
end
