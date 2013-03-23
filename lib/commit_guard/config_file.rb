module CommitGuard
  class ConfigFile
    CONFIG_FILENAME = '.commit_guard.yml'
    attr_reader :dir, :path, :name

    def initialize(name, dir)
      @name = name
      @dir = dir
      @path = dir.join(CONFIG_FILENAME)
    end

    def save
      File.open(path, 'w') {|f| f.puts config.to_yaml }
    end

    def config
      @config ||= begin
                    YAML.load_file(path) || {}
                  rescue Errno::ENOENT, TypeError
                    {}
                  end
    end

    def requires
      (config['requires'] ||= []).map {|x| dir.join(x).to_s }
    end

    def guards
      config['guards'] = [] unless config.has_key?('guards')
      config['guards']
    end

  end

end
