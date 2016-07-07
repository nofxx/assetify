#
# To be refactored...
#
module Assetify
  LINE = CLI.new

  class << self
    #
    # Text Interface
    #
    def check_param(params, string)
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

    def check(assets)
      assets.each do |a|
        LINE.p a.header
        if a.file_exists? # Return if file is on path
          a.read_data
          LINE.f "#{a.print_version} Installed"
        else
          LINE.f 'Not Found', :red
        end
      end
    end

    def install(assets, force = false)
      assets.each do |a|
        LINE.p a.header
        if !force && a.file_exists? # Return if file is on path
          a.read_data
          return LINE.f "#{a.print_version} Installed"
        end
        begin
          # Creates a thread to insert dots while downloading
          points = Thread.new { loop { ; LINE.p '.'; sleep 1; } }

          a.install! force
          LINE.f "#{a.print_version} ok"
        rescue => e
          LINE.f :FAIL, :red
          p "Fail: #{e} #{e.backtrace}"
        ensure
          points.kill
        end
      end
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
    def work_on(params)
      assets = find_assets(params[1])
      case params.first
      when /^i/, nil
        check_param params, 'install' if params[0]
        install assets
      when /^u/
        check_param params, 'update'
        install assets, :force
      when /^c/
        check_param params, 'check'
        check assets
      when /^w/
        check_param params, 'web'
        GUI.boot!
      else
        puts "Dunno how to #{params.join}."
      end
    end

    #
    # Divider bar
    #
    def bar
      puts '-' * TSIZE
    end

    def work!(params)
      start = Time.now
      Assetfile.find
      print "Assetify - #{Asset.all.size} assets"
      print " | #{params[1..-1].join(' . ')}" if params[1]
      puts ' |'
      bar
      work_on params
      bar
      puts "Done in #{Time.now - start}s"
    end
  end
end
