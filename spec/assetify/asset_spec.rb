require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Assetify::Asset do

  it "should spawn!" do
    as = Asset.new :js, "cool", "http://cool.js"
    as.should be_instance_of Asset
  end

  describe "Instantiated" do

    let (:as) { Asset.new :js, "sweet", "http://candy.js" }

    it "should have filename" do
      as.filename.should eql("sweet.js")
    end

    it "should have fullpath" do
      as.fullpath.should eql("vendor/assets/javascripts/sweet.js")
    end

    it "should detect version from strings" do
      as.instance_variable_set "@data", "/* foo v 1.5.6 */"
      as.print_version.should eql("v1.5.6")
    end

    it "should use sums for binaries version" do
      as.instance_variable_set "@data", "\u001F\x8B\b\u0000\xF5\u0000"
      as.print_version.should eql("v537c8396f74")
    end

    it "should use sums when can't find valid pattern" do
      as.instance_variable_set "@data", "I don't care versioning. 123"
      as.print_version.should eql("v03360413d77")
    end

  end

  describe "Namespaced" do

    let (:as) { Asset.new :js, "sweet", "http://candy.js", nil, :ns => "spacemonkey" }

    it "should have namespace" do
      as.ns.should eql("spacemonkey")
    end

    it "should have a namespaced path" do
      as.fullpath.should eql("vendor/assets/javascripts/spacemonkey/sweet.js")
    end

  end

  describe "On Package" do

    let (:as) { Asset.new :js, "sweet", "http://candy.js", nil, :pkg => "firefly" }

    it "should have name" do
      as.pkg.should eql("firefly")
    end

  end

  describe "Class methods" do

    it "should have all assets on hand" do
      Asset.all.should have(2).assets
    end

    it "should find assets" do
      Asset.filter("color").should have(1).assets
    end

    it "should find assets by pkg" do
      Asset.filter("mobile").should have(1).assets
    end

  end

end
