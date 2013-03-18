require 'yaml'
module CommitGuard
  class Configuration
    attr_reader :guards, :output

    def initialize(home_dir, working_dir, options={})
      config_files << CommitGuard::ConfigFile.new('Home Directory', home_dir)
      config_files << CommitGuard::ConfigFile.new('Working Directory', working_dir)
      @guards = []
      @output = $stdout
      @options = options
      load_config
    end

    def silent?
      @options[:silent]
    end

    def config_names
      config_files.map(&:name)
    end

    def config_files
      @config_files ||= []
    end

    def add_guard(config_name, builder)
      config = find_config(config_name)
      config.guards << builder.to_hash
      config.save
    end

    private

    def find_config(config_name)
      config_files.detect {|x| x.name == config_name }
    end

    def load_config
      config_files.each do |config|
        process_options(config)
      end
    end

    def process_options(config)
      @guards.concat config.guards
    end
  end
end
