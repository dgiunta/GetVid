require File.join File.dirname(__FILE__), "../../spec_helper"

module GetVid
  module Video
    describe YouTube do
      before(:each) do
        @url = 'http://www.youtube.com/watch?v=LXXAHe4V_4s'
        @youtube_src = Hpricot(fixture("youtube_source.html"))
        
        @yt = YouTube.new(@url)
        @yt.stub!(:open).and_return(@youtube_src)
        @yt.stub!(:original_src).any_number_of_times.and_return(@youtube_src)
      end
      
      context "when first created" do
        it "should have a contributor" do
          @yt.send(:contributor).should == "mostafahendry"
        end
        
        it "should include the contributor in the formatted filename" do
          @yt.send(:formatted_filename).should include("mostafahendry")
        end
        
        it "should have a video id" do
          @yt.send(:video_id).should == "LXXAHe4V_4s"
        end
        
        it "should have a download_token" do
          @yt.send(:download_token).should == "vjVQa1PpcFNDJwlyL7C73FGaxFTbOTWaBG1SEW4TuBw%3D"
        end
        
        it "should add the contributor to the id3 tags" do
          @yt.send(:formatted_id3_tags).should include("--ta 'mostafahendry'")
        end
      end
      
      context "getting the url to the downloadable movie file" do
        it "should not use keepvid.com" do
          @yt.send(:download_link).should_not include("keepvid.com")
        end
      
        it "should grab the &t= value from the youtube source" do
          @yt.send(:download_link).should == "http://www.youtube.com/get_video?video_id=LXXAHe4V_4s&t=vjVQa1PpcFNDJwlyL7C73FGaxFTbOTWaBG1SEW4TuBw%3D&fmt=22"
        end
      end
    end
  end
end
