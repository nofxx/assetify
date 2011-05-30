require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Helpers do
  include Helpers
  it "download stuff" do


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

  it "should rescue fine if there isn`t version" do
    find_version("/* --------------------------------------------------------------   reset.css   * Resets default browser CSS.").
      should be_empty
  end

end
