require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DSL do

  it "should group and use a namespace" do
    a = Assetify::DSL.parse("js 'foo', 'foolink'")[0]
    a.should be_an Asset
    a.fullpath.should eql("public/javascripts/foo.js")
  end


  describe "Group Assets" do

    it "should group and use a namespace" do
      a = Assetify::DSL.parse "group 'common' do; js 'foo', 'foolink'; end"
      a[0].should be_an Asset
      a[0].fullpath.should eql("public/javascripts/common/foo.js")
    end

    it "should group and use a namespace 2" do
      a = Assetify::DSL.parse "group 'common' do; js 'foo', 'foolink'; js 'rock', 'rocklink'; end"
      a[0].should be_an Asset
      a[0].fullpath.should eql("public/javascripts/common/foo.js")
    end

    it "should go back to root" do
      a = Assetify::DSL.parse "group 'common' do; js 'foo', 'foolink'; end; js 'rock', 'rocklink'"
      a[1].should be_an Asset
      a[1].fullpath.should eql("public/javascripts/rock.js")
    end

  end

  describe "Pkg Assets" do

    it "should group and use a namespace" do
      a = Assetify::DSL.parse "pkg 'fancy', 'http://fancy.zip' do; js 'foo', 'foolink'; end"
      a[0].should be_an Asset
      a[0].fullpath.should eql("public/javascripts/fancy/foo.js")
    end

    it "should fetch inside archive" do
      a = Assetify::DSL.parse "pkg 'fancy', 'http://fancy.zip' do; js 'foo', 'foolink'; end"
      a[0].should be_an Asset
      a[0].fullpath.should eql("public/javascripts/fancy/foo.js")
    end

  end


end
