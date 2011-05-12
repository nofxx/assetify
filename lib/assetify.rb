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
      File.open("Jsfile").lines.map do |line|
        next if line =~ /^\w*\#|^#/
        if line =~ /^\w{2,3}path/
          key, val = line.split(" ")
          Opt[key.to_sym] = val
          next
        end
        DSL.instance_eval(line)
      end.reject(&:nil?)
    end

    def work_on params
      case params.first
      when /^i/, nil
        @assets.map(&:install!)
      end
    end

    def work!(params)
      find_jsfile
      @assets = read_jsfile
      work_on params
    end


  end
end
