module CommitGuard
  class GuardBuilder
    attr_reader :for_class, :properties
    def initialize(for_class)
      @for_class = for_class
      @properties = []
    end

    def property(*args)
      properties << GuardProperty.new(*args)
    end

    def property_for(name)
      properties.detect {|x| x.name == name }
    end

    def config &block
      instance_eval &block
    end


  end
end
