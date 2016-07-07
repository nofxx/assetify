require 'spec_helper'

describe Assetify do
  it 'shoud read_assetfile' do
    mock_assetfile
    expect(Assetfile.read.size).to eq(1)
  end

  it 'should skip comments' do
    mock_assetfile("#\n# Oi\n#\n")
    expect(Assetfile.read).to be_nil
  end

  it 'should work with versions url' do
    mock_assetfile("#\n# Oi\n#\njs 'down', 'http://js.com/down-{VERSION}.js', '1.6'")
    expect(Assetfile.read.first.url).to eql('http://js.com/down-1.6.js')
  end

  describe 'read css' do
    before do
      mock_assetfile("#\n# CSS\n#\ncss 'grid', 'http://grid.com/down'")
    end
    let(:asset) { Assetfile.read[0] }

    it 'should read css' do
      expect(Assetfile.read.size).to eq(1)
    end

    it 'should read css' do
      expect(Assetfile.read.first.type).to eql(:css)
    end

    it 'should have fullpath' do
      expect(asset.fullpath).to eql('vendor/assets/stylesheets/grid.css')
    end
  end

  describe 'readjs' do
    let(:asset) { mock_assetfile; Assetfile.read[0] }

    it 'should be an asset' do
      expect(asset).to be_an Assetify::Asset
    end

    it 'should be a js file' do
      expect(asset.type).to eql(:js)
    end

    it 'should have an url' do
      expect(asset.url).to eql('http://cool.js/down')
    end

    it 'should have a name' do
      expect(asset.name).to eql('cool')
    end

    it 'should have fullpath' do
      expect(asset.fullpath).to eql('vendor/assets/javascripts/cool.js')
    end
  end
end
