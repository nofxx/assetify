require 'spec_helper'

describe Assetify::Asset do

  it "should spawn!" do
    as = Asset.new :js, "cool", "http://cool.js"
    expect(as).to be_instance_of Asset
  end

  describe "Instantiated" do

    let (:as) { Asset.new :js, "sweet", "http://candy.js" }

    it "should have filename" do
      expect(as.filename).to eql("sweet.js")
    end

    it "should have fullpath" do
      expect(as.fullpath).to eql("vendor/assets/javascripts/sweet.js")
    end

    it "should detect version from strings" do
      as.instance_variable_set "@data", "/* foo v 1.5.6 */"
      expect(as.print_version).to eql("v1.5.6")
    end

    it "should use sums for binaries version" do
      as.instance_variable_set "@data", "\u001F\x8B\b\u0000\xF5\u0000"
      expect(as.print_version).to eql("v537c8396f74")
    end

    it "should use sums when can't find valid pattern" do
      as.instance_variable_set "@data", "I don't care versioning. 123"
      expect(as.print_version).to eql("v03360413d77")
    end

  end

  describe "Namespaced" do

    let (:as) { Asset.new :js, "sweet", "http://candy.js", nil, :ns => "spacemonkey" }

    it "should have namespace" do
      expect(as.ns).to eql("spacemonkey")
    end

    it "should have a namespaced path" do
      expect(as.fullpath).to eql("vendor/assets/javascripts/spacemonkey/sweet.js")
    end

  end

  describe "On Package" do

    let (:as) { Asset.new :js, "sweet", "http://candy.js", nil, :pkg => "firefly" }

    it "should have name" do
      expect(as.pkg).to eql("firefly")
    end

  end

  describe "Class methods" do

    it "should have all assets on hand" do
      expect(Asset.all.size).to eq(2)
    end

    it "should find assets" do
      expect(Asset.filter("color").size).to eq(1)
    end

    it "should find assets by pkg" do
      expect(Asset.filter("mobile").size).to eq(1)
    end

  end

end
