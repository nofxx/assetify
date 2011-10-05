require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Pathfix do

  it "should spawn!" do
    f = Pathfix.new "fu"
    f.should be_instance_of Assetify::Pathfix
  end

  describe "Simple test" do

    let (:f) { Pathfix.new ".tipsy { padding: 5px;  background-image: url(../images/tipsy.gif); }" }

    it "should detect images" do
      f.images.should eql(["../images/tipsy.gif"])
    end

    it "should change css" do
      f.fixed.should eql ".tipsy { padding: 5px;  background-image: image-url('tipsy.gif'); }"
    end

  end

  describe "Multiple assets test" do

    let (:f) { Pathfix.new "div.rating-cancel,div.rating-cancel a{background:url(delete.gif) no-repeat 0 -16px}
div.star-rating,div.star-rating a{background:url(star.gif) no-repeat 0 0px}" }

    it "should detect images" do
      f.images.should eql(["delete.gif", "star.gif"])
    end

    it "should change css" do
      f.fixed.should eql "div.rating-cancel,div.rating-cancel a{background:image-url('delete.gif') no-repeat 0 -16px}\ndiv.star-rating,div.star-rating a{background:image-url('star.gif') no-repeat 0 0px}"
    end

  end

  it "should convert to sass" do
    css = Pathfix.new ".tipsy { padding: 5px;  background-image: url(../images/tipsy.gif); }"
    css.to_sass.should eql("1")
  end

end
