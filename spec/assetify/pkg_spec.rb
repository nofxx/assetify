require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Pkg do

  it "should spawn!" do
    as = Pkg.new "cool", "http://cool.js"
    as.should be_instance_of Pkg
  end

  it "should spawn!" do
    as = Pkg.new "cool", "http://cool.js"
    as.should be_instance_of Pkg
  end

  it "should get file from unpack" do
    `mkdir /tmp/fancy` unless Dir.exists? "/tmp/fancy"
    `cp spec/fixtures/fancy.tgz /tmp/fancy`
    as = Pkg.new "fancy", "http://fancy.tgz"
    as.get("fancy/fancy.css").should eql("// Fancy css!\n\n#foo {\n  padding: 10px;\n}\n")

  end

end
