require 'yaml'
module CommitGuard
  class Configuration
    CONFIG_FILENAME = '.commit_guard.yml'
    attr_reader :guards, :working_dir, :home_dir, :output
    def initialize(home_dir, working_dir)
      @home_dir = home_dir
      @working_dir = working_dir
      @guards = []
      @output = $stdout
      load_config
    end


    private

    def load_config
      [@home_dir, @working_dir].each do |dir|
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
