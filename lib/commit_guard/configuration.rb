require 'yaml'
module CommitGuard
  class Configuration
    CONFIG_FILENAME = '.commit_guard.yml'
    attr_reader :guards, :working_dir, :home_dir, :output

    def initialize(home_dir, working_dir, options={})
      @home_dir = home_dir
      @working_dir = working_dir
      @guards = []
      @output = $stdout
      @options = options
      load_config
    end

    def silent?
      @options[:silent]
    end

    def save
      File.open(home_dir, 'w') {|f| f.puts home_config.to_yaml }
      File.open(working_dir, 'w') {|f| f.puts working_dir_config.to_yaml }
    end

    def update_home(builder)
      guards_for(home_config)<< builder.to_hash
      save
    end

    def update_working_dir(builder)
      guards_for(working_dir_config) << builder.to_hash
      save
    end

    def home_config
      @home_config ||= begin
        YAML.load_file(home_dir.join(CONFIG_FILENAME))
      rescue Errno::ENOENT
        {}
       end
    end

    def working_dir_config
      @working_dir_config ||= begin
        YAML.load_file(working_dir.join(CONFIG_FILENAME))
      rescue Errno::ENOENT
        {}
      end
    end

    private

    def load_config
      [home_config, working_dir_config].each do |config|
        process_options(config)
      end
    end

    def guards_for(hsh)
      hsh['guards'] = [] unless hsh.has_key?('guards')
      hsh['guards']
    end


    def process_options(options)
      @guards.concat Array(options['guards'])
    end
  end
end
