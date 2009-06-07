module GetVid
  class Collection < Array
    def zip_all
      zip_files(make_zip_filename_for(GetVid.config.output_dir.split("/")[-1]))
    end
    
    def zip_audio
      zip_files(make_zip_filename_for(GetVid.config.audio_output_dir.split("/")[-1]))
    end
    
    def zip_video
      zip_files(make_zip_filename_for(GetVid.config.video_output_dir.split("/")[-1]))
    end
    
    def make_zips
      zip_all
      zip_audio
      zip_video
    end
    
    def make_zip_filename_for(dir)
      [Time.now.strftime("%Y-%m-%d_%H%M%S"), dir].join("-") + ".zip"
    end
    
    def zip_files(input, output=GetVid.config.output_dir)
      system("tar czfv #{File.join(GetVid.config.output_dir, input)} #{output}")
    end
    
    def method_missing(method, *args)
      if method.to_s.include?("_and_")
        method.to_s.split("_and_").each do |meth|
          self.send(meth, *args)
        end
      elsif self[0].respond_to?(method)
        each { |video| video.send(method, *args) }
      else
        super
      end
    end
  end  
end
