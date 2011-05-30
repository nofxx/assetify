require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Pkg do


  before do
    `mkdir /tmp/fancy` unless Dir.exists? "/tmp/fancy"
    `cp spec/fixtures/fancy.tgz /tmp/fancy`
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
    as.get("fancy/fancy.css").should eql("// Fancy css!\n\n#foo {\n  padding: 10px;\n}\n")

  end

end
