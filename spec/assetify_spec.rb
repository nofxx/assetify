require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Assetify do

  it "shoud read_jsfile" do
    mock_jsfile
    Assetify.read_jsfile.should have(1).asset
  end

  it "should skip comments" do
    mock_jsfile("#\n# Oi\n#\n")
    Assetify.read_jsfile.should be_nil
  end

  it "should work with versions url" do
    mock_jsfile("#\n# Oi\n#\njs 'down', 'http://js.com/down-{VERSION}.js', '1.6'")
    Assetify.read_jsfile.first.url.should eql("http://js.com/down-1.6.js")
  end

  describe "read css" do
    before do
      mock_jsfile("#\n# CSS\n#\ncss 'grid', 'http://grid.com/down'")
    end
    let(:asset) { Assetify.read_jsfile[0] }

    it "should read css" do
      Assetify.read_jsfile.should have(1).asset
    end

    it "should read css" do
      Assetify.read_jsfile.first.type.should eql(:css)
    end

    it "should have fullpath" do
      asset.fullpath.should eql("vendor/assets/stylesheets/grid.css")
    end

  end

  describe "readjs" do

    let(:asset) { mock_jsfile; Assetify.read_jsfile[0] }

    it "should be an asset" do
      asset.should be_an Assetify::Asset
    end

    it "should be a js file" do
      asset.type.should eql(:js)
    end

    it "should have an url" do
      asset.url.should eql("http://cool.js/down")
    end

    it "should have a name" do
      asset.name.should eql("cool")
    end

    it "should have fullpath" do
      asset.fullpath.should eql("vendor/assets/javascripts/cool.js")
    end


  end


end
