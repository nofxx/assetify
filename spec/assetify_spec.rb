require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Assetify do

  it "shoud read_assetfile" do
    mock_assetfile
    Assetify.read_assetfile.should have(1).asset
  end

  it "should skip comments" do
    mock_assetfile("#\n# Oi\n#\n")
    Assetify.read_assetfile.should be_nil
  end

  it "should work with versions url" do
    mock_assetfile("#\n# Oi\n#\njs 'down', 'http://js.com/down-{VERSION}.js', '1.6'")
    Assetify.read_assetfile.first.url.should eql("http://js.com/down-1.6.js")
  end

  describe "read css" do
    before do
      mock_assetfile("#\n# CSS\n#\ncss 'grid', 'http://grid.com/down'")
    end
    let(:asset) { Assetify.read_assetfile[0] }

    it "should read css" do
      Assetify.read_assetfile.should have(1).asset
    end

    it "should read css" do
      Assetify.read_assetfile.first.type.should eql(:css)
    end

    it "should have fullpath" do
      asset.fullpath.should eql("vendor/assets/stylesheets/grid.css")
    end

  end

  describe "readjs" do

    let(:asset) { mock_assetfile; Assetify.read_assetfile[0] }

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
