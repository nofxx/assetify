require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Pathfix do

  it "should spawn!" do
    f = Pathfix.new "fu"
    f.should be_instance_of Assetify::Pathfix
  end

  describe "Simple test ERB" do

    let (:f) { Pathfix.new ".tipsy { padding: 5px;  background-image: url(../images/tipsy.gif); }" }

    it "should detect images" do
      f.images.should eql(["../images/tipsy.gif"])
    end

    it "should change css" do
      f.fix.should eql ".tipsy { padding: 5px;  background-image: url('<%= image_path('tipsy.gif') %>'); }"
    end

  end

  describe "Simple test namespaced ERB" do

    let (:f) { Pathfix.new ".tipsy { padding: 5px;  background-image: url(../images/tipsy.gif); }", :erb, :nicelib }

    it "should detect images" do
      f.images.should eql(["../images/tipsy.gif"])
    end

    it "should change css" do
      f.fix.should eql ".tipsy { padding: 5px;  background-image: url('<%= image_path('nicelib/tipsy.gif') %>'); }"
    end

  end


  describe "Multiple assets test sass" do

    let (:f) { Pathfix.new "div.rating-cancel,div.rating-cancel a{background:url(delete.gif) no-repeat 0 -16px}
div.star-rating,div.star-rating a{background:url(star.gif) no-repeat 0 0px}", :sass }

    it "should detect images" do
      f.images.should eql(["delete.gif", "star.gif"])
    end

    it "should change css" do
      f.fix.should eql "div\n  &.rating-cancel\n    background: image-url(\"delete.gif\") no-repeat 0 -16px\n    a\n      background: image-url(\"delete.gif\") no-repeat 0 -16px\n  &.star-rating\n    background: image-url(\"star.gif\") no-repeat 0 0px\n    a\n      background: image-url(\"star.gif\") no-repeat 0 0px\n"
    end

  end

  describe "Multiple assets test scss" do

    let (:f) { Pathfix.new "div.rating-cancel,div.rating-cancel a{background:url(delete.gif) no-repeat 0 -16px}
div.star-rating,div.star-rating a{background:url(star.gif) no-repeat 0 0px}", :scss }

    it "should detect images" do
      f.images.should eql(["delete.gif", "star.gif"])
    end

    it "should change css" do
      f.fix.should eql "div {\n  &.rating-cancel {\n    background: image-url(\"delete.gif\") no-repeat 0 -16px;\n    a {\n      background: image-url(\"delete.gif\") no-repeat 0 -16px; } }\n  &.star-rating {\n    background: image-url(\"star.gif\") no-repeat 0 0px;\n    a {\n      background: image-url(\"star.gif\") no-repeat 0 0px; } } }\n"
    end

  end

  describe "Multiple assets test big css minified file" do

    let (:f) { Pathfix.new File.read("#{File.dirname(__FILE__)}/../fixtures/mobile.css"), :scss }

    it "should detect images" do
      f.images.should eql(["images/icons-18-white.png", "images/icons-18-black.png", "images/icons-36-white.png", "images/icons-36-black.png", "images/ajax-loader.png"])
    end

    # it "should change css" do
    #   f.fix.should match "background-image: image-url(\"images/icons-36-white.png\")"
    # end

  end

end
