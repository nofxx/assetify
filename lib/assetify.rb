require "assetify/tui"
module Assetify

  Opt = {
    :vendor   =>  "public/vendor",
    :newname  =>  true
  }

  TSIZE = 80
  LINE  = TUI.new
  ASSETS_PATH = "vendor/assets"
  ASSETS = [:javascripts, :stylesheets, :images]
  ASSETS.each do |asset|
    Opt.merge!(asset => "#{ASSETS_PATH}/#{asset}")
  end

  class NoJSFile < StandardError
  end
end

# Ruby Extensions
require "assetify/extensions/string"

# Core
require "assetify/helpers"
require "assetify/asset"
require "assetify/dsl"

# Text Interface
require "assetify/cli/term"
require "assetify/cli/colored"
require "assetify/cli"
