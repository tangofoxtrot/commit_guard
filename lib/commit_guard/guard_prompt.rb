require 'highline'
module CommitGuard
  class GuardPrompt

    attr_reader :highline, :configuration
    attr_accessor :builder

    def initialize(configuration, input = $stdin, output = $stdout)
      @configuration = configuration
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

    def confirm
      highline.say builder.preview.join("\n")
      result = highline.ask "Would you like to save this Guard? (Y/N)"
      if result.upcase == 'Y'
        prompt_to_save
      end
    end

    def prompt_to_save
      home_dir = 'Home directory'
      working_dir = 'Working directory'
      result = highline.choose do |menu|
        menu.prompt = 'Where would you like to save this guard to?'
        menu.choices(home_dir, working_dir)
      end
      if result == home_dir
        configuration.update_home(builder)
      elsif result == working_dir
        configuration.update_working(builder)
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
      if property.multiple?
        highline.say "#{property.name}: Add additional values (leave blank when finished)"
        value = prompt.call
        until value == ''
          property.value = value
          value = prompt.call
        end
      end
    end

  end
end
