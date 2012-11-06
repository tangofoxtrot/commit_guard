module CommitGuard
  module Guards
    class Base
      def initialize(path, options={})
        @path = path
        @options = options
      end

      def valid?
        true
      end
    end
  end
end
