require 'yaml'
module CommitGuard
  class Configuration
    CONFIG_FILENAME = '.commit_guard.yml'
    attr_reader :guards, :working_dir
    def initialize(home_dir, working_dir)
      @home = home_dir
      @working_dir = working_dir
      @guards = []
      load_config
    end

    private

    def load_config
      [@home, @working_dir].each do |dir|
        begin
          process_options(YAML.load_file(dir.join(CONFIG_FILENAME)))
        rescue Errno::ENOENT
        end
      end
    end

    def process_options(options)
      @guards.concat options['guards']
    end
  end
end
