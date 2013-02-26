module CommitGuard
  class GuardProperty
    attr_reader :name, :value

    def initialize *attributes
      @name = attributes.shift
      @options = attributes.last
      @value = multiple? ? [] : nil
    end

    def required?
      option_for(:required) || false
    end

    def multiple?
      option_for(:multiple) || false
    end

    def value=(new_value)
      if multiple?
        @value << new_value
      else
        @value = new_value
      end
    end

    private
    def option_for(key)
      @options && @options[key]
    end
  end
end
