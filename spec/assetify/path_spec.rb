require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Path do

  it "should spawn!" do
    f = Path::Findr.new "fu"
    f.should be_instance_of Path::Findr
  end

  describe "Instantiated" do

    let (:f) { Path::Findr.new ".tipsy { padding: 5px;  background-image: url(../images/tipsy.gif); }" }

    it "should detect images" do
      f.images.should eql(["../images/tipsy.gif"])
    end

    it "should change css" do
      f.fixed.should eql ".tipsy { padding: 5px;  background-image: url(../images/tipsy.gif); }"
    end

  end

end
