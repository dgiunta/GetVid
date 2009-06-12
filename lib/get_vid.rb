require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'fileutils'
require 'open3'

Dir[File.join(File.dirname(__FILE__), "get_vid", "**/*.rb")].each { |f| require f }

module GetVid  
  def self.from_links(links)
    Video.from_links(links)
  end
  
  def self.configure(&block)
    @@config = Configuration.new(&block)
    @@config.create_dirs!
    @@config
  end
  
  def self.config
    @@config ||= configure
  end
end