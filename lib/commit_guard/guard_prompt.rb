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
      prompt = Proc.new do
        highline.ask "#{property.name} (#{property.description}) :"
      end
      property.value = prompt.call
      until property.valid?
        highline.say "#{property.name} is required".colorize(:red)
        property.value = prompt.call
      end
    end

  end
end
