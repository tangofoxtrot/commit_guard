module CommitGuard
  module Guards
    class Base
      def initialize(configuration, options={})
        @configuration = configuration
        @options = options
      end

      def valid?
        true
      end

      class << self
        def build &block
          @builder ||= CommitGuard::GuardBuilder.new(self)
          @builder.config &block
        end

        def builder
          @builder
        end

      end

      private
      attr_reader :configuration
    end
  end
end
