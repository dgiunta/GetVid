require File.join File.dirname(__FILE__), "../spec_helper"

module GetVid
  describe Configuration do
    before(:each) do
      @config = Configuration.new
    end
    
    context "when first created" do
      context "without a block given" do
        it "should have an output dir" do
          @config.output_dir.should == File.expand_path("~/Desktop/GetVidOutput")
        end
    
        it "should have an audio dir" do
          @config.audio_dir.should == "Audio"
        end
    
        it "should have a video dir" do
          @config.video_dir.should == "Video"
        end
    
        it "should have an audio_output_dir" do
          @config.audio_output_dir.should == File.expand_path("~/Desktop/GetVidOutput/Audio")
        end

        it "should have a video_output_dir" do
          @config.video_output_dir.should == File.expand_path("~/Desktop/GetVidOutput/Video")
        end
      end
      
      context "with a block given" do
        before(:each) do
          @config = Configuration.new do |conf|
            conf.output_dir = "~/Desktop/CustomOutput"
            conf.audio_dir = "CustomAudio"
            conf.video_dir = "CustomVideo"
          end
        end
        
        it "should have a custom output dir" do
          @config.output_dir.should == File.expand_path("~/Desktop/CustomOutput")
        end
    
        it "should have a custom audio dir" do
          @config.audio_dir.should == "CustomAudio"
        end
    
        it "should have a custom video dir" do
          @config.video_dir.should == "CustomVideo"
        end
    
        it "should have a custom audio_output_dir" do
          @config.audio_output_dir.should == File.expand_path("~/Desktop/CustomOutput/CustomAudio")
        end

        it "should have a custom video_output_dir" do
          @config.video_output_dir.should == File.expand_path("~/Desktop/CustomOutput/CustomVideo")
        end
      end
    end
    
    context "making the directories" do
      before(:each) do
        @config = Configuration.new do |conf|
          conf.output_dir = fixture_path_for("CustomOutput")
        end
        @config.create_dirs!
      end
      
      after(:each) do
        FileUtils.rm_rf(fixture_path_for("CustomOutput"))
      end
      
      it "should create the output directory" do
        File.should be_exists(fixture_path_for("CustomOutput"))
        File.should be_directory(fixture_path_for("CustomOutput"))
      end
      
      it "should create the audio directory" do
        File.should be_exists(fixture_path_for("CustomOutput/Audio"))
        File.should be_directory(fixture_path_for("CustomOutput/Audio"))
      end
      
      it "should create the video directory" do
        File.should be_exists(fixture_path_for("CustomOutput/Video"))
        File.should be_directory(fixture_path_for("CustomOutput/Video"))
      end
    end
  end  
end
