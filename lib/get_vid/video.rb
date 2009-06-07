module GetVid
  class Video
    attr_reader :url
  
    def self.from_links(links)
      links = links.kind_of?(Array) ? links : links.split(/\n/)
      Collection.new(links.collect { |url| new(url) })
    end
  
    def initialize(url)
      @url = url
    end
  
    def download
      system("wget #{download_link} -O #{video_filepath}")
    end
    
    def export_audio
      unless File.exists?(audio_filename)
        system("sudo qt_export #{video_filepath} #{audio_filepath} --video=0 --replacefile")
      end
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
  
    def contributor
      @contributor ||= (original_src/'.contributor').first.inner_html
    end
  
    def title
      @title ||= (original_src/'h1').first.inner_html
    end
  
    def filename
      [contributor, title.gsub(/\W+/, '_').gsub(/\_+$/, '')].join("-")
    end
    
    def audio_filename
      filename[0..26] + ".aif"
    end
    
    def video_filename
      filename + ".mp4"
    end
    
    def audio_filepath
      File.join(GetVid.config.audio_output_dir, audio_filename)
    end
    
    def video_filepath
      File.join(GetVid.config.video_output_dir, video_filename)
    end
  end
end