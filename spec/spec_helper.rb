require 'rubygems'
require 'spec'

require File.join(File.dirname(__FILE__), '../lib/get_vid')

def fixture(path)
  File.open(fixture_path_for(path))
end

def fixture_path_for(path, expand_path=false)
  path = File.join(File.dirname(__FILE__), "fixtures/#{path}")
  return File.expand_path(path) if expand_path
  return path
end