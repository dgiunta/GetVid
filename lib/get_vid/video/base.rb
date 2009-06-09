module GetVid
  module Video
    class Base
      attr_reader :url

      def initialize(url)
        @url = url
      end

      def download
        File.open(video_filepath, "w+") do |file|
          open(download_link) do |stream|
            file.write(stream.read)
          end
        end
        # system("wget #{download_link} -O #{video_filepath}")
      end

      def export_audio
        IO.popen("ffmpeg -i #{video_filepath} #{audio_filepath}") unless File.exists?(audio_filepath)
      end
      
      def convert_audio_to_mp3
        command = "lame -h #{audio_filepath} #{audio_filepath('mp3')}"
        command << " " + formatted_id3_tags unless formatted_id3_tags.nil? || formatted_id3_tags.match(/[^ ]/).to_s.length == 0
        IO.popen(command)
      end
      
      private

      def original_src
        @original_src ||= open(@url) { |f| Hpricot(f) }
      end

      def keepvid_src
        @keepvid_src ||= open("http://keepvid.com/?url=#{@url}&fmt=22") { |f| Hpricot(f) }
      end

      def download_link
        @download_link ||= "http://keepvid.com" + (keepvid_src/'a').select {|l| l["href"] =~ /^.*\.mp4.*/ }.first["href"]
      end

      def title
        @title ||= (original_src/'h1').first.inner_html
      end

      def filename
        [title.gsub(/\W+/, '_').gsub(/\_+$/, '')].join("-")
      end
      
      # Template method that you can override in subclasses to format a nicer filename with additional info
      def formatted_filename
        filename
      end
      
      def id3_tags
        @id3_tags ||= {
          :tt => title,
          :tc => [url]
        }
      end
      
      # Template method that can be overridden in subclasses to alter the id3_tags hash above.
      def additional_id3_tags
        {}
      end
      
      def formatted_id3_tags
        id3_tags.merge!(additional_id3_tags).collect do |k, v|
          v = v.join("\n") if v.is_a?(Array)
          "--#{k} '#{v}'"
        end.join(" ")
      end

      def audio_filepath(extension = 'aif')
        File.join(GetVid.config.audio_output_dir, [formatted_filename, extension].join("."))
      end

      def video_filepath(extension = 'mp4')
        File.join(GetVid.config.video_output_dir, [formatted_filename, extension].join("."))
      end
    end
  end
end