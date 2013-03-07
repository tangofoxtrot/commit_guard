module CommitGuard
  class GuardBuilder
    attr_reader :for_class, :properties

    def initialize(for_class)
      @for_class = for_class
      @properties = []
    end

    def name
      for_class.name
    end

    def property(*args)
      properties << GuardProperty.new(*args)
    end

    def property_for(name)
      properties.detect {|x| x.name == name }
    end

    def remove_property(name)
      properties.delete(property_for(name))
    end

    def set(name, value)
      property_for(name).value = value
    end

    def remove(name, index=nil)
      property_for(name).remove(index)
    end

    def value(name)
      property_for(name).value
    end

    def config &block
      instance_eval &block
    end

  end
end
