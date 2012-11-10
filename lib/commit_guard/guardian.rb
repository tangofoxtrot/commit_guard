module CommitGuard
  class Guardian
    attr_reader :guards
    def initialize(configuration)
      @configuration = configuration
      @guards = []
      initialize_guards
    end

    def run
      guards.each(&:call)
    end

    def success?
      !guards.map(&:valid?).compact.include?(false)
    end

    private

    def initialize_guards
      @configuration.guards.each do |guard|
        guards << initialize_guard(guard)
      end
    end

    def initialize_guard(guard_config)
      CommitGuard::Guards.const_get(guard_config['type'].capitalize).new(guard_config)
    end
  end
end