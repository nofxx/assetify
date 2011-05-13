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

  end


end
