require 'colorize'
module CommitGuard
  module Guards
    class Grep < Base
      attr_reader :options, :result
      class Builder
        class Property
          attr_reader :name
          def initialize *attributes
            @name = attributes.shift
            @options = attributes.last
          end

          def required?
            @options[:required] || false
          end

          def multiple?
            @options[:multiple] || false
          end
        end
        def initialize(clazz)
          @clazz = clazz
          @properties = []
        end

        def config &block
          instance_eval &block
        end

        def property *args
          @properties << Property.new(*args)
        end

        def properties(name)
          @properties.detect {|x| x.name == name }
        end
      end

      class << self
        def build &block
          @builder ||= Builder.new(self)
          @builder.config &block
        end

        def builder
          @builder
        end

      end

      build do
        property :pattern, :description => 'Grep pattern', :required => true
        property :path, :description => 'Paths to search in', :required => true, :multiple => true
        property :exclude, :description => 'Paths or files to exclude', :required => false, :multiple => true
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
        @result ||= `#{command}`
        self
      end

      def command
        "fgrep -R -n #{options['regex']} -s #{paths.join(" ")} #{exclude_dir_options}"
      end

      def exclude_dirs
        Array(options['exclude'])
      end

      def exclude_dir_options
        exclude_dirs.map{|x| "| grep -v #{x}" }.join(' ')
      end

      def working_dir
        configuration.working_dir
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
