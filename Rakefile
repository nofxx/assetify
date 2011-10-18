# encoding: utf-8
require 'bundler'
Bundler.setup

require "rake"
require "rdoc/task"
require "rspec"
require "rspec/core/rake_task"

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "assetify/version"

task :gem => :build
task :build do
  system "gem build assetify.gemspec"
end

task :install => :build do
  system "sudo gem install assetify-#{Assetify::VERSION}.gem"
end

task :release => :build do
  system "git tag -a v#{Assetify::VERSION} -m 'Tagging #{Assetify::VERSION}'"
  system "git push --tags"
  system "gem push assetify-#{Assetify::VERSION}.gem"
end


# require 'rspec/core'
# require 'rspec/core/rake_task'
# RSpec::Core::RakeTask.new(:spec) do |spec|
#   spec.pattern = FileList['spec/**/*_spec.rb']
# end

# RSpec::Core::RakeTask.new(:rcov) do |spec|
#   spec.pattern = 'spec/**/*_spec.rb'
#   spec.rcov = true
# end

# task :default => :spec

# require 'rdoc/task'
# RDoc::Task.new do |rdoc|
#   version = File.exist?('VERSION') ? File.read('VERSION') : ""

#   rdoc.rdoc_dir = 'rdoc'
#   rdoc.title = "assetify #{version}"
#   rdoc.rdoc_files.include('README*')
#   rdoc.rdoc_files.include('lib/**/*.rb')
# end
