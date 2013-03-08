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

    def valid?
      if required?
        has_value?
      else
        true
      end
    end

    def remove(index=nil)
      if multiple?
        @value.delete_at(index)
      else
        @value = nil
      end
    end

    def description
      option_for :description
    end


    private

    def has_value?
      if multiple?
        value.any? {|x| value_present?(x) }
      else
        value_present?(value)
      end
    end

    def value_present?(the_value)
      the_value.to_s.strip != ''
    end

    def option_for(key)
      @options && @options[key]
    end
  end
end
