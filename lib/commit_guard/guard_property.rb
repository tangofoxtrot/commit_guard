module CommitGuard
  class GuardProperty
    attr_reader :name
    def initialize *attributes
      @name = attributes.shift
      @options = attributes.last
    end

    def required?
      @options[:required] || false
    end

    def multiple?
      @options[:multiple] || false
    end
  end
end
