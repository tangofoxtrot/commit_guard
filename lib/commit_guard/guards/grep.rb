require 'colorize'
module CommitGuard
  module Guards
    class Grep < Base
      attr_reader :options, :result

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
        "#{self.class.name.split("::").last} Guard"
      end

      def description
        if valid?
          valid_description
        else
          invalid_description
        end
      end

      def paths
        Array(options['path']).map {|path| working_dir.join(path) }
      end

      def run
        call
      end

      private

      def call
        @result ||= `fgrep -R #{options['regex']} -s #{paths.join(" ")}`
        self
      end

      def working_dir
        configuration.working_dir
      end

      def valid_description
        "Check OK".colorize(:green)
      end

      def invalid_description
        "Check failed: #{options['regex']}\n #{result.split("\n").map {|x| "-- #{x}"}.join("\n")}".colorize(:red)
      end
    end
  end
end
