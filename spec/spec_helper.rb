require 'rspec'
require 'commit_guard'
require 'pathname'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
end

def fixture_path(dir_name)
  Pathname.new(File.dirname(__FILE__)).join('fixtures', dir_name)
end

def invalid_project
  fixture_path('invalid_project')
end

def valid_project
  fixture_path('valid_project')
end

def home_dir
  fixture_path('home')
end
