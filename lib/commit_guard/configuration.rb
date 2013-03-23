require 'yaml'
module CommitGuard
  class Configuration
    attr_reader :guards, :output, :pwd

    def initialize(home_dir, working_dir, options=nil)
      config_files << CommitGuard::ConfigFile.new('Home Directory', Pathname.new(home_dir))
      config_files << @pwd = CommitGuard::ConfigFile.new('Working Directory', Pathname.new(working_dir))
      @guards = []
      @output = $stdout
      @options = options
      load_config
    end

    def silent?
      @options && @options.silent
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

    def pwd
     @pwd.dir
    end

    def requires
      config_files.map {|x| x.requires }.inject(&:+)
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
