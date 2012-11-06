module CommitGuard
  module Guards
    class Firebug < Base
      attr_reader :path, :options, :result

      def valid?
        call
        result.length == 0
      end

      def invalid?
        !valid?
      end

      def call
        @result ||= `fgrep -R firebug #{path.join('features')}`
      end

      def title
        "#{self.class.name.split("::").last} Guard"
      end

      def description
        if valid?
        else
          failure_description
        end
      end

      private
      def failure_description
        "Check failed\n #{result.split("\n").map {|x| "-- #{x}"}.join("\n")}"
      end
    end
  end
end
