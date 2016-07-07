module Assetify
  class CLI
    def initialize(size = TSIZE)
      @size = size
      @chars = 0
    end

    def p(txt)
      @chars += txt.size
      print txt
    end

    def f(txt, color = :green)
      puts "[#{txt}]".send(color).bold.rjust (TSIZE - @chars + 17)
      @chars = 0
    end
  end
end
