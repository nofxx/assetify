module Assetify
  #
  # The Assetfile!
  #
  class Assetfile
    class << self
      #
      # Assetfile stuff
      #
      def missing!
        print 'Assetfile not found, create one? [Y/n] '
        res = $stdin.gets.chomp # dont forget stdin
        unless res =~ /n|N/
          File.open('Assetfile', 'w+') do |f|
            f.print <<TXT
#
# #{Dir.pwd.split('/').last.capitalize} Assetfile
#

js  :jquery, "http://jquery.com"
css :reset,  "http://prefered/rset/url"

group :forms do
  js :validator, "http://..."
end

TXT
          end
          puts 'Assetfile created!'
          exit 0
        end
      end

      #
      # Assetfile find/read
      #
      #
      def find
        missing! unless File.exist?('Assetfile')
      end

      def read
        file = File.open('Assetfile') # ruby 1.8/1.9 (ugly) fix
        code = file.each_line.map do |line|
          # Parse options
          if line =~ /^\w{2,3}path/
            key, val = line.split(' ')
            Opt[key.to_sym] = val
            next
          end
          line
        end.reject(&:nil?)
        DSL.parse code.join('')
      end

      # def write
      # end
    end
  end
end
