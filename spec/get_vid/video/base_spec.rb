require File.join(File.dirname(__FILE__), "../../spec_helper")

module GetVid
  module Video
    describe Base do
      before(:each) do
        GetVid.configure do |conf|
          conf.output_dir = fixture_path_for("TestOutput")
        end
      
        @url            = "http://www.youtube.com/watch?v=LXXAHe4V_4s"
        @keepvid_url    = "http://keepvid.com/?url=#{@url}&fmt=22"
        @filename       = "the_longest_yard_2006_here_comes_the_boom"
        @original_src   = Hpricot(fixture("youtube_source.html"))
        @keepvid_src    = Hpricot(fixture("keepvid_source.html"))
        @download_link  = 'http://keepvid.com/save-video.mp4?http%3A%2F%2Fv13.lscache1.googlevideo.com%2Fvideoplayback%3Fip%3D0.0.0.0%26sparams%3Did%252Cexpire%252Cip%252Cipbits%252Citag%26itag%3D18%26ipbits%3D0%26sver%3D3%26expire%3D1244332800%26key%3Dyt1%26signature%3D8BDE5AC46DED1640E43E8B6E2E928D710CDF8318.548DAF24C32055F3E238AB874A47CB0343004E56%26id%3D2d75c01dee15ff8b'
      
        @video_output_file = File.join(fixture_path_for("TestOutput/Video", true), @filename) + ".mp4"
        @audio_output_file = File.join(fixture_path_for("TestOutput/Audio", true), @filename) + ".aif"
        @mp3_audio_file    = File.join(fixture_path_for("TestOutput/Audio", true), @filename) + ".mp3"
      
        @gv = Base.new(@url)
        @gv.stub!(:open).with(@url).and_return(@original_src)
        @gv.stub!(:open).with(@keepvid_url).and_return(@keepvid_src)
        @gv.stub!(:system)
      end
    
      after(:each) do
        FileUtils.rm_rf(fixture_path_for("TestOutput"))
      end
  
      context "when first created" do
        it "should have a url" do
          @gv.url.should == @url
        end
    
        it "should have a title" do
          @gv.send(:title).should == "the longest yard 2006 (here comes the boom !)"
        end
    
        it "should have a filename" do
          @gv.send(:filename).should == @filename
        end
    
        it "should have a download_link" do
          @gv.send(:download_link).should == @download_link
        end

        it "should have a video filepath" do
          @gv.send(:video_filepath).should == @video_output_file
        end
      
        it "should have an audio filepath" do
          @gv.send(:audio_filepath).should == @audio_output_file
        end
        
        it "should have an mp3 filepath by passing the mp3 extension to audio_filepath" do
          @gv.send(:audio_filepath, 'mp3').should == @mp3_audio_file
        end
      end
  
      context "when downloading the video" do
        it "should create a new mp4 file to save data to" do
          File.should_receive(:open).with(@video_output_file, "w+").and_return(true)
          @gv.download
        end
        
        it "should download the file at the download_link location" do
          @gv.should_receive(:open).with(@download_link).and_return(true)
          @gv.download
        end
      end
    
      context "when exporting audio" do
        it "should hand off audio processing to ffmpeg" do
          IO.should_receive(:popen).with("ffmpeg -i #{@video_output_file} #{@audio_output_file}")
          @gv.export_audio
        end
      
        it "should not run the qt_export command if the file already exists" do
          File.should_receive(:exists?).and_return(true)
          IO.should_not_receive(:popen)
          @gv.export_audio
        end
        
        it "should convert the aif file to mp3" do
          @gv.should_receive(:formatted_id3_tags).any_number_of_times.and_return("")
          IO.should_receive(:popen).with("lame -h #{@audio_output_file} #{@mp3_audio_file}")
          @gv.convert_audio_to_mp3
        end
        
        it "should add ID3 tags to the mp3" do
          @gv.send(:formatted_id3_tags).should include("--tt 'the longest yard 2006 (here comes the boom !)'")
          @gv.send(:formatted_id3_tags).should include("--tc '#{@url}'")
        end
      end
    end

  end
end
