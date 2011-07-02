require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Pkg do


  before do
    [:fancy, :complex].each do |ns|
      `mkdir /tmp/#{ns}` unless Dir.exists? "/tmp/#{ns}"
      `cp spec/fixtures/#{ns}.tgz /tmp/#{ns}/`
    end
  end

  it "should spawn!" do
    stub_request(:get, "http://cool.js/fancy.tgz").to_return(:body => "Hi")
    as = Pkg.new "cool", "http://cool.js/fancy.tgz"
    as.should be_instance_of Pkg
  end

  it "should spawn!" do
    as = Pkg.new "cool", "http://cool.js"
    as.should be_instance_of Pkg
  end

  it "should get file from unpack" do
    as = Pkg.new "fancy", "/tmp/fancy/fancy.tgz"
    as.get("fancy/fancy.css").should eql("fancy/fancy.css" => "// Fancy css!\n\n#foo {\n  padding: 10px;\n}\n")
  end

  it "should read all assets within pkg" do
    as = Pkg.new "complex", "/tmp/complex/complex.tgz"
    as.read_from_pkg.should be_a Hash #(hash_including "complex/images/3.png"=>"Im a png image..3\n")
  end

  it "should unpack all to vendor" do
    as = Pkg.new "complex", "/tmp/complex/complex.tgz"
    as.unpack_to_vendor #.should be_a Hash #(hash_including "complex/images/3.png"=>"Im a png image..3\n")
    File.exists?("public/vendor/complex/src/main.js").should be_true
    `rm -rf vendor/assets/vendor`
  end

end
