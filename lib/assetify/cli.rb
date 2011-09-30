#
# To be refactored...
#
module Assetify
  class << self

    #
    # Jsfile stuff
    #
    def no_jsfile!
      print "Jsfile not found, create one? [Y/n] "
      res = gets.chomp
      unless res =~ /n|N/
        File.open("Jsfile", "w+") do |f|
          f.print <<TXT
#
# #{Dir.pwd.split('/').last.capitalize} Jsfile
#

js  :jquery, "http://jquery.com"
css :reset,  "http://prefered/rset/url"

group :forms do
  js :validator, "http://..."
end

TXT
        end
        puts "Jsfile created!"
        exit 0
      end
    end

    def find_jsfile
      no_jsfile! unless File.exists?("Jsfile")
    end

    def read_jsfile
      file = File.open("Jsfile") # ruby 1.8/1.9 (ugly) fix
      code = file.send(file.respond_to?(:lines) ? :lines : :readlines).map do |line|
        # Parse options
        if line =~ /^\w{2,3}path/
          key, val = line.split(" ")
          Opt[key.to_sym] = val
          next
        end
        line
      end.reject(&:nil?)
      DSL.parse code.join("")
    end

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
    def find_assets(filter = nil)
      return @assets unless filter
      @assets.select {  |a| "#{a.name}#{a.pkg}" =~ /#{filter}/ }
    end

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
        gui!
      else
        puts "Dunno how to #{params.join}."
      end
    end

    def bar
      puts "-" * TSIZE
    end

    def gui!
      require "assetify/gui/server"
      Sinatra::Application.run!
    end

    def work!(params)
      start = Time.now
      puts "Assetify"
      bar
      find_jsfile
      Asset.set_all @assets = read_jsfile
      work_on params
      bar
      puts "Done in #{Time.now - start}s"
    end


  end
end
