require 'spec_helper'

describe Assetify::Helpers do
  BINDATA = File.read(File.join(File.dirname(__FILE__), "..", "fixtures", "complex.tgz"))

  include Assetify::Helpers

  it "should detect text as not binary" do
    "I'm not a cylon!".should_not be_binary
    "/*** Comment nice for v1.4.5 ***/".should_not be_binary
  end

  it "should detect robot talk as binary" do
    BINDATA.should be_binary
    "\u001F\x8B\b\u0000\xF5\u0000".should be_binary
  end

  it "should find from a long version" do
    find_version("frips 1.5.7.786").should eql(["1.5.7.786", 1, 5, 7, 786])
  end

  it "should find version from text" do
    find_version("Foo v 1.5.6").should eql(["1.5.6", 1, 5, 6])
  end

  it "should find version from text" do
    find_version("/*!\n * jQuery JavaScript Library v1.6\n * http://jquery.com/\n *\n * Copyright 2011, John Resig\n * Date: Mon May 2 13:50:00 2011 -0400").
      should eql(["1.6", 1, 6])
  end

  it "should find version from binary" do
    find_version(BINDATA).should eql("c29b335e572251b1b79b88bf8c2847ec")
  end

  it "should rescue fine if there isn`t version" do
    find_version("/* --------------------------------------------------------------   reset.css   * Resets default browser CSS.").
      should eql("d356b6a91b0d16e456c7b4f79302d051")
  end

end
