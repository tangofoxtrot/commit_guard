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
      private
      attr_reader :configuration
    end
  end
end
