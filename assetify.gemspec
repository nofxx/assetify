# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{assetify}
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Marcos Piccinini"]
  s.date = %q{2011-07-02}
  s.default_executable = %q{assetify}
  s.description = %q{Downloads/updates assets based on a Jsfile. Any framework.}
  s.email = %q{x@nofxx.com}
  s.executables = ["assetify"]
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "Gemfile.lock",
    "Jsfile",
    "README.md",
    "Rakefile",
    "VERSION",
    "assetify.gemspec",
    "bin/assetify",
    "lib/assetify.rb",
    "lib/assetify/asset.rb",
    "lib/assetify/colored.rb",
    "lib/assetify/dsl.rb",
    "lib/assetify/helpers.rb",
    "lib/assetify/pkg.rb",
    "lib/assetify/tui.rb",
    "spec/assetify/asset_spec.rb",
    "spec/assetify/dsl_spec.rb",
    "spec/assetify/helpers_spec.rb",
    "spec/assetify/pkg_spec.rb",
    "spec/assetify_spec.rb",
    "spec/fixtures/complex.tgz",
    "spec/fixtures/fancy.tgz",
    "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/nofxx/assetify}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Downloads/updates assets. Any framework.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 2.3.0"])
      s.add_development_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 2.3.0"])
      s.add_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<webmock>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 2.3.0"])
    s.add_dependency(%q<bundler>, [">= 1.0.0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<webmock>, [">= 0"])
  end
end

