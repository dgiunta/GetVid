Dir[File.join(File.dirname(__FILE__), "video/**/*.rb")].each { |f| require f }

module GetVid
  module Video
    def self.create(url, *args)
      case true
      when url.include?("youtube.com")
        return Video::YouTube.new(url, *args)
      else
        return Video::Base.new(url, *args)
      end
    end
  end  
end
