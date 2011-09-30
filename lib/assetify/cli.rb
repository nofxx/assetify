#
# To be refactored...
#
module Assetify
  LINE  = CLI.new

  class << self

    #
    # Text Interface
    #
    def check_param params, string
      unless string.include? params[0]
        puts "Did you mean #{string}?"
        exit 0
      end
    end

    # Fuzzy find files
    def find_assets(params = nil)
      return Asset.all unless params
      Asset.filter params
    end

    #
    # CLI Master case/switch!
    #
    # Destructive:
    # i -> install
    # u -> update
    # x -> clean ? todo
    #
    # Safe:
    # c -> check
    # w -> web
    #
    def work_on params
      case params.first
      when /^i/, nil
        check_param params, "install" if params[0]
        find_assets(params[1]).map(&:install!)
      when /^u/
        check_param params, "update"
        find_assets(params[1]).map { |a| a.install! :force }
      when /^c/
        check_param params, "check"
        find_assets(params[1]).map { |a| a.check! }
      when /^w/
        check_param params, "web"
        GUI.boot!
      else
        puts "Dunno how to #{params.join}."
      end
    end

    #
    # Divider bar
    #
    def bar
      puts "-" * TSIZE
    end

    def work!(params)
      start = Time.now
      Assetfile.find
      puts "Assetify - #{Asset.all.size} assets"
      bar
      work_on params
      bar
      puts "Done in #{Time.now - start}s"
    end

  end

end
