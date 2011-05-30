module Assetify

  class TUI
    def initialize(size = 80)
      @size = 80
      @chars = 0
    end

    def p txt
      @chars += txt.size
      print txt
    end

    def f txt
      puts "[#{txt}]".rjust (50 - @chars)
      @chars = 0
    end
  end
end
