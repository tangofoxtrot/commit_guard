require 'colorize'
module CommitGuard
  module Guards
    class Grep < Base

      build do
        property :pattern, :description => 'Grep pattern', :required => true
        property :path, :description => 'Paths to search in', :required => true, :multiple => true
        property :exclude, :description => 'Paths or files to exclude', :required => false, :multiple => true
      end

      def paths
        Array(options['path']).map {|path| pwd.join(path) }
      end

      def title
        "#{self.class.name.split("::").last} Guard [#{options['pattern']}]"
      end

      private

      def command
        "fgrep -R -n #{options['pattern']} -s #{paths.join(" ")} #{exclude_dir_options}"
      end

      def exclude_dirs
        Array(options['exclude']).select {|x| !x.nil? && x != '' }
      end

      def exclude_dir_options
        exclude_dirs.map{|x| "| grep -v #{x}" }.join(' ') unless exclude_dirs.empty?
      end

      def pwd
        configuration.pwd
      end

    end
  end
end
