module Assetify
  #
  # Web View
  #
  class GUI
    def self. boot!
      require 'assetify/gui/server'
      Sinatra::Application.run!
    end
  end
end
