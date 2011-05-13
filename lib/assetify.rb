require "assetify/asset"
require "assetify/dsl"

module Assetify

  class NoJSFile < StandardError
  end

  Opt = {
    :jspath   =>  "public/javascripts",
    :csspath  =>  "public/stylesheets",
    :imgpath  =>  "public/images",
    :newname  =>  true
  }

  class << self

    def no_jsfile!
      print "Jsfile not found, create one? [Y/n] "
      res = gets.chomp
      unless res =~ /n|N/
        File.open("Jsfile", "w+") do |f|
          f.print <<TXT
a :foox, "http://foox.com"
TXT
        end
        puts "Jsfile created!"
      end
    end

    def find_jsfile
      no_jsfile! unless File.exists?("Jsfile")
    end

    def read_jsfile
      file = File.open("Jsfile") # ruby 1.8/1.9 (ugly) fix
      code = file.send(file.respond_to?(:lines) ? :lines : :readlines).map do |line|
        next if line =~ /^\w*\#|^#/
        if line =~ /^\w{2,3}path/
          key, val = line.split(" ")
          Opt[key.to_sym] = val
          next
        end
        line
      end.reject(&:nil?)
      DSL.parse code.join(";")
    end

    def check_param params, string
      unless string.include? params[0]
        puts "Did you mean #{string}?"
        exit 0
      end
    end

    def work_on params
      case params.first
      when /^i/, nil
        check_param params, "install" if params[0]
        @assets.map(&:install!)
      when /^u/
        check_param params, "update"
        @assets.map { |a| a.install! :force }
      else
        puts "Dunno how to #{params.join}."
      end
    end

    def work!(params)
      find_jsfile
      @assets = read_jsfile
      work_on params
    end


  end
end
