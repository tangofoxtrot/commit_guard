require 'highline'
module CommitGuard
  class GuardPrompt

    attr_reader :highline
    attr_accessor :builder

    def initialize(input = $stdin, output = $stdout)
      @input = input
      @output = output
      @highline = HighLine.new(@input, @output)
    end

    def choose_guard(guards = [])
      result = highline.choose do |menu|
        menu.prompt = 'Select a Guard'
        menu.choices(*guards.map(&:name))
      end

      self.builder = guards.detect {|x| x.name == result}.builder
    end

    def populate
      builder.properties.each do |prop|
        prompt_for_property(prop)
      end
    end

    def prompt_for_property(property)
      property.value = highline.ask "#{property.name} (#{property.description}) :"
    end

  end
end
