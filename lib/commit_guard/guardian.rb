module CommitGuard
  class Guardian
    attr_reader :guards, :configuration
    def initialize(configuration)
      @configuration = configuration
      @guards = []
      initialize_guards
    end

    def run
      guards.each(&:run)
      results
    end

    def success?
      !guards.map(&:valid?).compact.include?(false)
    end

    def results
      guards_for_output.each do |guard|
        configuration.output.puts guard.display
      end
    end

    private

    def guards_for_output
      if configuration.silent?
         guards.select(&:invalid?)
      else
        guards
      end
    end

    def initialize_guards
      @configuration.guards.each do |guard|
        guards << initialize_guard(guard)
      end
    end

    def initialize_guard(guard_config)
      CommitGuard::Guards.const_get(guard_config['type'].capitalize).new(configuration, guard_config)
    end
  end
end
