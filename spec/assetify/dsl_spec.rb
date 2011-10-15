require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Assetify::DSL do

  it "should parse js nicely" do
    a = Assetify::DSL.parse("js 'foo', 'foolink'")[0]
    a.should be_an Asset
    a.fullpath.should eql("vendor/assets/javascripts/foo.js")
  end

  it "should parse css nicely" do
    a = Assetify::DSL.parse("css 'foo', 'foolink'")[0]
    a.should be_an Asset
    a.fullpath.should eql("vendor/assets/stylesheets/foo.css")
  end

  it "should parse img nicely (gif)" do
    a = Assetify::DSL.parse("img 'foo.gif', 'foolink'")[0]
    a.should be_an Asset
    a.fullpath.should eql("vendor/assets/images/foo.gif")
  end

  it "should parse img nicely from link (gif)" do
    a = Assetify::DSL.parse("img 'foo', 'foolink.gif'")[0]
    a.should be_an Asset
    a.fullpath.should eql("vendor/assets/images/foo.gif")
  end

  it "should parse img nicely from link (png)" do
    a = Assetify::DSL.parse("img 'foo', 'foolink-ra.png'")[0]
    a.should be_an Asset
    a.fullpath.should eql("vendor/assets/images/foo.png")
  end

  it "should parse js with global 'a' keyword" do
    a = Assetify::DSL.parse("a 'foo', 'foolink.js'")[0]
    a.should be_an Asset
    a.fullpath.should eql("vendor/assets/javascripts/foo.js")
  end

  it "should parse js with global 'asset' alias too" do
    a = Assetify::DSL.parse("asset 'foo', 'foolink.js'")[0]
    a.should be_an Asset
    a.fullpath.should eql("vendor/assets/javascripts/foo.js")
  end

  it "should parse css with global 'a' keyword" do
    a = Assetify::DSL.parse("a 'foo', 'http://w.foolink/c/?foo.css'")[0]
    a.should be_an Asset
    a.fullpath.should eql("vendor/assets/stylesheets/foo.css")
  end

  it "should parse img with global 'a' keyword" do
    a = Assetify::DSL.parse("a 'foo.gif', 'foolink.gif'")[0]
    a.should be_an Asset
    a.fullpath.should eql("vendor/assets/images/foo.gif")
  end

  it "should accept a especific location with :to" do
    Dir.should_receive(:pwd).and_return("/home/user/git/assetify")
    a = Assetify::DSL.parse("rb 'foo', 'foolink', :to => 'spec/rock'")[0]
    a.should be_an Asset
    a.fullpath.should eql("/home/user/git/assetify/spec/rock/foo.rb")
  end

  it "should not fail with symbols" do
    a = Assetify::DSL.parse("js :jnice, 'foolink'")[0]
    a.should be_an Asset
    a.name.should eql("jnice")
  end

  describe "Templates and Pathfixes" do

    it "should parse css to erb nicely" do
      a = Assetify::DSL.parse("css 'foo', 'foolink', :as => :erb")[0]
      a.should be_an Asset
      a.fullpath.should eql("vendor/assets/stylesheets/foo.css.erb")
    end

    it "should parse css to sass nicely" do
      a = Assetify::DSL.parse("css 'foo', 'foolink', :as => :sass")[0]
      a.should be_an Asset
      a.fullpath.should eql("vendor/assets/stylesheets/foo.css.sass")
    end

  end

  describe "Group Assets" do

    it "should group and use a namespace" do
      a = Assetify::DSL.parse "group 'common' do; js 'foo', 'foolink'; end"
      a[0].should be_an Asset
      a[0].fullpath.should eql("vendor/assets/javascripts/common/foo.js")
    end

    it "should group and use a namespace 2" do
      a = Assetify::DSL.parse "group 'common' do; js 'foo', 'foolink'; js 'rock', 'rocklink'; end"
      a[0].should be_an Asset
      a[0].fullpath.should eql("vendor/assets/javascripts/common/foo.js")
    end

    it "should go back to root" do
      a = Assetify::DSL.parse "group 'common' do; js 'foo', 'foolink'; end; js 'rock', 'rocklink'"
      a[1].should be_an Asset
      a[1].fullpath.should eql("vendor/assets/javascripts/rock.js")
    end

    it "should work with nested namespaces" do
      a = Assetify::DSL.parse "group 'common' do; group 'nice' do; js 'foo', 'foolink'; end; end"
      a[0].should be_an Asset
      a[0].fullpath.should eql("vendor/assets/javascripts/common/nice/foo.js")
    end

  end

  describe "Pkg Assets" do

    it "should group and use a namespace" do
      a = Assetify::DSL.parse "pkg 'fancy', 'http://fancy.zip' do; js 'foo', 'foolink'; end"
      a[0].should be_an Asset
      a[0].fullpath.should eql("vendor/assets/javascripts/fancy/foo.js")
    end

    it "should use name as namespace too" do
      a = Assetify::DSL.parse "pkg 'complex', '/tmp/complex/complex.tgz' do; dir 'images/*'; end"
      a.should have(3).assets
      a[0].fullpath.should eql("vendor/assets/images/complex/two.png")
    end

    it "should accept shallow too" do
      a = Assetify::DSL.parse "pkg 'fancy', 'http://fancy.zip', :shallow => true do; js 'foo', 'foolink'; end"
      a[0].should be_an Asset
      a[0].fullpath.should eql("vendor/assets/javascripts/foo.js")
    end

    it "should fetch inside archive" do
      a = Assetify::DSL.parse "pkg 'fancy', 'http://fancy.zip' do; js 'foo', 'foolink'; end"
      a[0].should be_an Asset
      a[0].fullpath.should eql("vendor/assets/javascripts/fancy/foo.js")
    end

    it "should unpack to vendor if no block given" do
      Pkg.should_receive(:new).with("fancy", "http://fancy.zip").and_return(mp = mock(Pkg))
      mp.should_receive :unpack_all
      a = Assetify::DSL.parse "pkg 'fancy', 'http://fancy.zip'"
    end
  end

  describe "Directories" do

    it "should read from pkg the regex" do
      Pkg.should_receive(:new).with("fancy", "http://fancy.zip").and_return(mp = mock(Pkg))
      mp.should_receive(:get).with("images/").and_return([])
      a = Assetify::DSL.parse "pkg 'fancy', 'http://fancy.zip' do; dir 'images/', :to => 'images/complex/'; end"
    end

    it "should read from pkg the regex" do
      Dir.should_receive(:pwd).and_return("/home/user/git/assetify")

      as = Assetify::DSL.parse "pkg 'complex', 'http://complex.tgz' do; dir 'images/', :to => 'images/complex/'; end"
      as[0].name.should eql("two")
      as[0].ext.should eql("png")
      as[0].fullpath.should eql("/home/user/git/assetify/images/complex/two.png")
    end

  end

  describe "Paths" do

    it "should change js path" do
      Assetify::DSL.parse "javascripts 'other/foo'"
      Opt[:javascripts].should eql('other/foo')
    end

    it "should change css path" do
      Assetify::DSL.parse "stylesheets 'other/foo'"
      Opt[:javascripts].should eql('other/foo')
    end
  end

end
