require 'colorize'
module CommitGuard
  module Guards
    class Grep < Base
      attr_reader :options, :result

      build do
        property :pattern, :description => 'Grep pattern', :required => true
        property :path, :description => 'Paths to search in', :required => true, :multiple => true
        property :exclude, :description => 'Paths or files to exclude', :required => false, :multiple => true
      end

      def paths
        Array(options['path']).map {|path| working_dir.join(path) }
      end

      private

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

    end
  end
end
