# encoding: utf-8

require 'rubygems'
require 'bundler'
require './lib/assetify/version'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "assetify"
  gem.homepage = "http://github.com/nofxx/assetify"
  gem.license = "MIT"
  gem.summary = %Q{Downloads/updates assets. Any framework.}
  gem.description = %Q{Downloads/updates assets based on an Assetfile. Any framework.}
  gem.email = "x@nofxx.com"
  gem.authors = ["Marcos Piccinini", "Rafael Barbosa"]
  gem.post_install_message = <<-POST_INSTALL_MESSAGE

A #{'-' * 60} A

                  *   A  S  S  E  T  I  F  Y   *

Thank you for installing assetify-#{Assetify::VERSION}.

Here is a few optional gems:

 * libarchive    -  For untar/unzip packages
 * minimagick    -  For image transformations
 * sass          -  For css2sass support


We hope `assetify` saves you some time!

A #{'-' * 60} A
POST_INSTALL_MESSAGE
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rdoc/task'
RDoc::Task.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "assetify #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
