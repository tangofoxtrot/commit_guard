module CommitGuard
  class Runner
    attr_reader :configuration, :guardian

    def initialize(working_dir)
      @configuration = CommitGuard::Configuration.new(Pathname.new(ENV['HOME']), Pathname.new(working_dir))
      @guardian = CommitGuard::Guardian.new(configuration)
    end

    def run
      guardian.run
    end

  end
end
