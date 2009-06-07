module GetVid
  class Configuration
    attr_writer :output_dir
    attr_accessor :audio_dir, :video_dir
    
    def initialize
      @output_dir = "~/Desktop/GetVidOutput/"
      @audio_dir = "Audio"
      @video_dir = "Video"

      yield(self) if block_given?
    end
    
    def output_dir
      File.expand_path(@output_dir)
    end
    
    def audio_output_dir
      File.join(output_dir, audio_dir)
    end
    
    def video_output_dir
      File.join(output_dir, video_dir)
    end

    def create_dirs!
      [output_dir, audio_output_dir, video_output_dir].each do |dir|
        FileUtils.makedirs(dir) unless File.exists?(dir) && File.directory?(dir)
      end
    end
    
    def to_s
      ["Output Directory: " + output_dir,
      "Audio Directory: " + audio_output_dir,
      "Video Directory: " + video_output_dir].join("\n")
    end
  end
end