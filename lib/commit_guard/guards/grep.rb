module CommitGuard
  module Guards
    class Grep < Base
      attr_reader :path, :options, :result

      def valid?
        call
        result.length == 0
      end

      def invalid?
        !valid?
      end

      def call
        @result ||= `fgrep -R #{options['regex']} #{path.join(options['path'].join(' '))}`
      end

      def title
        "#{self.class.name.split("::").last} Guard"
      end

      def description
        if valid?
          valid_description
        else
          invalid_description
        end
      end

      private
      def valid_description
        "Check OK"
      end

      def invalid_description
        "Check failed: #{options['regex']}\n #{result.split("\n").map {|x| "-- #{x}"}.join("\n")}"
      end
    end
  end
end
