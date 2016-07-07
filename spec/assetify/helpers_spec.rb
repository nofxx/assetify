require 'spec_helper'

describe Assetify::Helpers do
  BINDATA = File.read(File.join(File.dirname(__FILE__), "..", "fixtures", "complex.tgz"))

  include Assetify::Helpers

  it "should detect text as not binary" do
    expect("I'm not a cylon!").not_to be_binary
    expect("/*** Comment nice for v1.4.5 ***/").not_to be_binary
  end

  it "should detect robot talk as binary" do
    expect(BINDATA).to be_binary
    expect("\u001F\x8B\b\u0000\xF5\u0000").to be_binary
  end

  it "should find from a long version" do
    expect(find_version("frips 1.5.7.786")).to eql(["1.5.7.786", 1, 5, 7, 786])
  end

  it "should find version from text" do
    expect(find_version("Foo v 1.5.6")).to eql(["1.5.6", 1, 5, 6])
  end

  it "should find version from text" do
    expect(find_version("/*!\n * jQuery JavaScript Library v1.6\n * http://jquery.com/\n *\n * Copyright 2011, John Resig\n * Date: Mon May 2 13:50:00 2011 -0400")).
      to eql(["1.6", 1, 6])
  end

  it "should find version from binary" do
    expect(find_version(BINDATA)).to eql("c29b335e572251b1b79b88bf8c2847ec")
  end

  it "should rescue fine if there isn`t version" do
    expect(find_version("/* --------------------------------------------------------------   reset.css   * Resets default browser CSS.")).
      to eql("d356b6a91b0d16e456c7b4f79302d051")
  end

end
