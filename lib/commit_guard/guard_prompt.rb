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
        menu.choices(*guards.map(&:title))
      end

      self.builder = guards.detect {|x| x.title == result}.builder
    end

    def populate
      builder.properties.each do |prop|
        prompt_for_property(prop)
      end
    end

    def perform
      choose_guard([CommitGuard::Guards::Grep])
      populate
      confirm
    end

    def confirm
      highline.say builder.preview.join("\n")
      result = highline.ask "Would you like to save this Guard? (Y/N)"
      if result.upcase == 'Y'
        prompt_to_save
      end
    end

    def prompt_to_save
      result = highline.choose do |menu|
        menu.prompt = 'Where would you like to save this guard to?'
        menu.choices(*configuration.config_names)
      end
      configuration.add_guard(result, builder)
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

      if !property.blank? && property.multiple?
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
