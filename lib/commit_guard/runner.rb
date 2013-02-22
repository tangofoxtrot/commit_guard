module CommitGuard
  class Runner
    attr_reader :configuration, :guardian

    def initialize(working_dir, options={})
      @configuration = CommitGuard::Configuration.new(Pathname.new(ENV['HOME']), Pathname.new(working_dir), options)
      @guardian = CommitGuard::Guardian.new(configuration)
    end

    def run
      guardian.run
    end

    def exit_status
      guardian.success? ? 0 : 1
    end

  end
end
