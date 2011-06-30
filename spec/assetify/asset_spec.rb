require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Asset do

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
      as.fullpath.should eql("public/javascripts/sweet.js")
    end

    it "should detect version" do
      as.instance_variable_set "@data", "/* foo v 1.5.6 */"
      as.ver[0].should eql("1.5.6")
    end

    it "should print version" do
      as.instance_variable_set "@data", "\u001F\x8B\b\u0000\xF5\u0000"
      as.print_version.should eql("v537c8396f74 ")
    end
  end

end
