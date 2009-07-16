require File.join(File.dirname(__FILE__), "../spec_helper")
require 'time'

module GetVid
  describe Collection do
    before(:each) do
      GetVid.configure do |conf|
        conf.output_dir = fixture_path_for("TestOutput")
      end
      @output_dir = File.expand_path(fixture_path_for("TestOutput"))
      Time.stub!(:now).and_return(Time.parse("Sun Jun 07 12:28:22 -0000 2009").getutc)

      @video = Video::Base.new("http://youtube.com")
      @collection = Collection.new([@video])
    end
    
    after(:each) do
      FileUtils.rm_rf(fixture_path_for("TestOutput"))
    end
    
    it "should inherit from Array" do
      Collection.superclass.should == Array
    end
    
    it "should download" do
      @video.should_receive(:download).and_return(true)
      @collection.download
    end
    
    it "should export the audio" do
      @video.should_receive(:export_audio).and_return(true)
      @collection.export_audio
    end
    
    it "should download and export audio" do
      @video.should_receive(:download).and_return(true)
      @video.should_receive(:export_audio).and_return(true)
      @collection.download_and_export_audio
    end
    
    it "should zip audio and video files up into a dated zip file" do
      @collection.should_receive(:system).with("tar czfv #{fixture_path_for("TestOutput/2009-06-07_122822-TestOutput.zip", true)} #{@output_dir}").and_return(true)
      @collection.zip_all
    end

    it "should zip just audio files into a dated zip file" do
      @collection.should_receive(:system).with("tar czfv #{fixture_path_for("TestOutput/2009-06-07_122822-Audio.zip", true)} #{@output_dir}").and_return(true)
      @collection.zip_audio      
    end
    
    it "should zip just the video files into a dated zip file" do
      @collection.should_receive(:system).with("tar czfv #{fixture_path_for("TestOutput/2009-06-07_122822-Video.zip", true)} #{@output_dir}").and_return(true)
      @collection.zip_video
    end
    
    it "should create separate zip files for the compiled version, the audio only and the video only" do
      @collection.should_receive(:zip_all).and_return(true)
      @collection.should_receive(:zip_audio).and_return(true)
      @collection.should_receive(:zip_video).and_return(true)
      @collection.make_zips
    end
  end  
end
