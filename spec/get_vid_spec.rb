require File.join File.dirname(__FILE__), "spec_helper"

describe GetVid, ".from_links" do
  it "should pass the passed in links to Video.links" do
    links = ["http://youtube.com/?12345", "http://youtube.com/?12345"]
    GetVid::Video.should_receive(:from_links).with(links)
    GetVid.from_links(links)
  end
  
  context "when configuring" do
    after(:each) do
      FileUtils.rm_rf(File.expand_path("~/Desktop/GetVidOutput"))
      FileUtils.rm_rf(File.expand_path(fixture_path_for("TmpOutputDir")))
    end
    
    it "should return a Configuration object" do
      GetVid.configure
      GetVid.config.should be_instance_of(GetVid::Configuration)
      GetVid.config.output_dir.should == File.expand_path("~/Desktop/GetVidOutput")
    end
    
    it "should take a block and pass it to the Configuration object" do
      GetVid.configure do |config|
        config.output_dir = fixture_path_for("TmpOutputDir")
      end
      
      GetVid.config.output_dir.should == File.expand_path(fixture_path_for("TmpOutputDir"))
    end
  end
end