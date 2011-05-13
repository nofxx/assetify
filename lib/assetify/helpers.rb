module Assetify
  module Helpers

    private

    def print_result(txt, varchars = name)
      puts "[#{txt}]".rjust (47 - varchars.size)
    end

    def download
      uri = URI.parse url
      Net::HTTP.start(uri.host) do |http|
        @data = http.get(uri.path)
      end
    end

    def write
      FileUtils.mkdir_p path unless Dir.exists? path
      File.open(fullpath, "w") { |f| f.puts(@data) }
    end


  end
end
