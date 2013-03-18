module CommitGuard
  module Guards
    class Base
      class << self
        def build &block
          @builder ||= CommitGuard::GuardBuilder.new(self)
          @builder.config &block
        end

        def builder
          @builder
        end

        def title
          "#{name.split("::").last} Guard"
        end

        def yaml_name
          name.split("::").last
        end
      end

      def initialize(configuration, options={})
        @configuration = configuration
        @options = options
      end

      def valid?
        call.result.length == 0
      end

      def invalid?
        !valid?
      end

      def display
        "#{title}\n#{description}"
      end

      def title
        self.class.title
      end

      def yaml_name
        self.class.yaml_name
      end

      def description
        if valid?
          valid_description
        else
          invalid_description
        end
      end

      def run
        call
      end

      private

      attr_reader :configuration

      def call
        @result ||= `#{command}`
        self
      end

      def valid_description
        "Check OK #{options['regex']}".colorize(:green)
      end

      def invalid_description
        "Check failed: #{options['regex']}\n #{result.split("\n").map {|x| "-- #{x}"}.join("\n")}".colorize(:red)
      end
    end
  end
end
