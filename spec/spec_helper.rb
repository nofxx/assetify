$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rspec'
require 'webmock/rspec'
require 'assetify'

include Assetify # less typing

def mock_assetfile(d = 'js "cool", "http://cool.js/down"')
  expect(File).to receive(:open).once.with('Assetfile').and_return(d)
end

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
end
