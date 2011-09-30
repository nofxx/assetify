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