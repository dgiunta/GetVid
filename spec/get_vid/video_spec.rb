require File.join(File.dirname(__FILE__), "../spec_helper")

module GetVid
  describe Video do
    context "#from_links" do
      before(:each) do
        @string_links = <<-LINKS
        http://www.youtube.com/watch?v=LXXAHe4V_4s
        http://www.youtube.com/watch?v=t1pKyKyMI8k
        http://www.youtube.com/watch?v=iwsWEHbbBfI
        http://www.youtube.com/watch?v=7CVwShOQsRg
        http://www.youtube.com/watch?v=Qff6mcw3T-E
        LINKS
        @string_links.gsub!(/^ +/, '')
      end
  
      context "with an array of links" do
        before(:each) do
          @array_links = @string_links.split(/\n/)
          @gvs = Video.from_links(@array_links)
        end
    
        it "should create an array of YouTube objects" do
          @gvs.should be_kind_of(Collection)
          @gvs.should have(5).get_vids
          @gvs.first.should be_kind_of(Video::YouTube)
        end
      end
  
      context "with a string of links" do
        before(:each) do
          @gvs = Video.from_links(@string_links)
        end
  
        it "should create an array of YouTube objects" do
          @gvs.should be_kind_of(Collection)
          @gvs.should have(5).get_vids
          @gvs.first.should be_kind_of(Video::YouTube)
        end
      end
    end
    
    context "when creating video instances" do
      %w[ youtube.com http://youtube.com http://www.youtube.com http://www.youtube.com/?view=ASDFASDFASDF].each do |url|
        it "should create Video::YouTube's if the url passed is #{url}" do
          GetVid::Video.create(url).should be_instance_of(Video::YouTube)
        end
      end
    end
  end  
end
