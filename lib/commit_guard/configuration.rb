require 'yaml'
module CommitGuard
  class Configuration
    CONFIG_FILENAME = '.commit_guard.yml'
    attr_reader :guards
    def initialize(home_dir, project_path)
      @home = home_dir
      @project_path = project_path
      @guards = []
      load_config
    end

    private

    def load_config
      [@home, @project_path].each do |dir|
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
