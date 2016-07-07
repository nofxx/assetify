require 'spec_helper'

describe Assetify::Pkg do


  before do
    [:fancy, :complex].each do |ns|
      `mkdir /tmp/#{ns}` unless Dir.exists? "/tmp/#{ns}"
      `cp spec/fixtures/#{ns}.tgz /tmp/#{ns}/`
    end
  end

  it "should spawn!" do
    stub_request(:get, "http://cool.js/fancy.tgz").to_return(:body => "Hi")
    as = Pkg.new "cool", "http://cool.js/fancy.tgz"
    expect(as).to be_instance_of Pkg
  end

  it "should spawn!" do
    as = Pkg.new "cool", "http://cool.js"
    expect(as).to be_instance_of Pkg
  end

  it "should get file from unpack" do
    as = Pkg.new "fancy", "/tmp/fancy/fancy.tgz"
    expect(as.get("fancy/fancy.css")).to eql("fancy/fancy.css" => "// Fancy css!\n\n#foo {\n  padding: 10px;\n}\n")
  end

  it "should get file without path from unpack" do
    as = Pkg.new "fancy", "/tmp/fancy/fancy.tgz"
    expect(as.get("fancy.css")).to eql("fancy/fancy.css" => "// Fancy css!\n\n#foo {\n  padding: 10px;\n}\n")
  end

  it "should get file from part of the name" do
    as = Pkg.new "fancy", "/tmp/fancy/fancy.tgz"
    expect(as.get("cy.css")).to eql("fancy/fancy.css" => "// Fancy css!\n\n#foo {\n  padding: 10px;\n}\n")
  end

  it "should read all assets within pkg" do
    as = Pkg.new "complex", "/tmp/complex/complex.tgz"
    expect(as.read_from_pkg).to be_a Hash #(hash_including "complex/images/3.png"=>"Im a png image..3\n")
  end

  it "should unpack all to vendor" do
    as = Pkg.new "complex", "/tmp/complex/complex.tgz"
    as.unpack_all #.should be_a Hash #(hash_including "complex/images/3.png"=>"Im a png image..3\n")
    expect(File.exists?("public/vendor/complex/src/main.js")).to be_truthy
    `rm -rf vendor/assets/vendor`
  end

  it "should download pkg only once" do
    as = Pkg.new "fancy", "/tmp/fancy/fancy.tgz"

    expect(as).not_to receive(:write)

    as.get("fancy/fancy.css")
    as.get("fancy/fancy.css")
  end
end
