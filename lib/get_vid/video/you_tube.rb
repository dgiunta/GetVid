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
        scripts = (original_src/'script')
        puts scripts.length
        puts scripts.match(/\&t\=([^\&]*\&?)/).inspect
        @download_token ||= html.match(/\&t\=([^\&]*)\&?/).captures[0]
      end
      
      def download_link
        begin
          link = original_src.html.grep(/.*img\.src/)[0].match(/img\.src ?\= ?['"](.+)['"]/)
          url = URI.parse(link.captures[0])
          dl_link = ["http://", url.host, "/videoplayback?", url.query].join
          @download_link ||= dl_link
        rescue Exception => e
          @download_link = "ERROR"
        end
      end
      
      def formatted_filename
        [contributor.gsub(/\W/, "_"), filename].join("-")
      end
    end
  end
end