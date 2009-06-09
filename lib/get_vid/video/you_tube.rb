module GetVid
  module Video
    class YouTube < Base
      attr_reader :video_id
      
      def initialize(url)
        vid_id = url.match(/\?v=(.*)\&?/)
        @video_id ||= vid_id.captures[0] unless vid_id.nil?
        super
      end

      private
            
      def additional_id3_tags
        {
          :ta => contributor
        }
      end
      
      def contributor
        @contributor ||= (original_src/'.contributor').first.inner_html
      end
      
      def download_token
        @download_token ||= (original_src/'script').to_s.match(/\&t\=([^\&]*)\&?/).captures[0]
      end
      
      def download_link
        @download_link ||= "http://www.youtube.com/get_video?video_id=#{video_id}&t=#{download_token}&fmt=18"
      end
      
      def formatted_filename
        [contributor.gsub(/\W/, "_"), filename].join("-")
      end
    end
  end
end
