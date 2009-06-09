require File.join(File.dirname(__FILE__), "../spec_helper")

module GetVid
  describe Video do
    context "when creating video instances" do
      %w[ youtube.com http://youtube.com http://www.youtube.com http://www.youtube.com/?view=ASDFASDFASDF].each do |url|
        it "should create Video::YouTube's if the url passed is #{url}" do
          GetVid::Video.create(url).should be_instance_of(GetVid::Video::YouTube)
        end
      end
    end
  end  
end
