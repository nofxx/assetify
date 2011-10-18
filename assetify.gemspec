# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require "assetify/version"

Gem::Specification.new do |s|
  s.name = 'assetify'

  s.version     = Assetify::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Marcos Piccinini", "Rafael Barbosa"]
  s.email       = ["x@nofxx.com"]
  s.homepage    = "http://github.com/nofxx/assetify"
  s.summary     = "Manage your assets."
  s.description = "Downloads/updates assets based on an Assetfile. Any framework."

  s.required_rubygems_version = ">= 1.3.6"
  # s.rubyforge_project         = "assetify"

  s.executables = ["assetify"]
  s.default_executable = %q{assetify}

  s.files        = Dir.glob("lib/**/*") + %w(README.md Rakefile)
  s.require_path = 'lib'
  s.licenses = ["MIT"]

  s.post_install_message = %q{
A ------------------------------------------------------------ A

                  *   A  S  S  E  T  I  F  Y   *

Thank you for installing assetify-2.0.0.

Here is a few optional gems:

 * libarchive    -  For untar/unzip packages
 * minimagick    -  For image transformations
 * sass          -  For css2sass support


We hope `assetify` saves you some time!

A ------------------------------------------------------------ A
}

  s.add_development_dependency(%q<rspec>, [">= 2.3.0"])
  s.add_development_dependency(%q<bundler>, [">= 1.0.0"])
  s.add_development_dependency(%q<jeweler>, [">= 0"])
  s.add_development_dependency(%q<webmock>, [">= 0"])
  s.add_development_dependency(%q<sinatra>, [">= 0"])
  s.add_development_dependency(%q<libarchive>, [">= 0"])
end

