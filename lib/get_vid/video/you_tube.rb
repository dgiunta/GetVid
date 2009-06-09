module GetVid
  module Video
    class YouTube < Base
      attr_reader :video_id
      
      def initialize(url)
        @video_id ||= url.match(/\?v=(.*)\&?/).captures[0]
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
        @download_link ||= "http://www.youtube.com/get_video?video_id=#{video_id}&t=#{download_token}&fmt=22"
      end
      
      def formatted_filename
        [contributor, filename].join(" ")
      end
    end
  end
end
