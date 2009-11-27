require File.join(File.dirname(__FILE__), "../../spec_helper")

module GetVid
  module Video
    describe YouTube do
      before(:each) do
        @url = 'http://www.youtube.com/watch?v=LXXAHe4V_4s'
        @youtube_src = Hpricot(fixture("youtube_source_2.html"))
        
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
        
        it "should add the contributor to the id3 tags" do
          @yt.send(:formatted_id3_tags).should include("--ta 'mostafahendry'")
        end
      end
      
      context "using the embeded download link." do
        it "should properly set the download link variable" do
          @yt.send(:download_link).should == "http://v22.lscache6.c.youtube.com/videoplayback?ip=0.0.0.0&sparams=id%2Cexpire%2Cip%2Cipbits%2Citag%2Calgorithm%2Cburst%2Cfactor&fexp=905301%2C904804&algorithm=throttle-factor&itag=34&ipbits=0&burst=40&sver=3&expire=1259370000&key=yt1&signature=296B483065D2C5322CD47AD0796FAE70A6AE6819.8A381F9E53B9EB52932A99C1075E42555DED988B&factor=1.25&id=2d75c01dee15ff8b"
        end
      end
    end
  end
end
