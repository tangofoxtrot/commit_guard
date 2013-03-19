module CommitGuard
  class DefaultGenerator
    attr_reader :configuration

    def initialize(configuration)
      @configuration = configuration
    end

    def run
      defaults.each do |default|
        builder = CommitGuard::Guards::Grep.builder
        default.each do |key, value|
          Array(value).each do |val|
            builder.set(key.to_sym, val)
          end
        end
        configuration.add_guard('Home Directory', builder)
      end
    end

    def defaults
      [
        {"path"=>["features"],"pattern"=>"@firebug"},
        {"path"=>["features"], "pattern"=>"[^\\^]let me see that"},
        {"path"=>["features"], "pattern"=>"[^\\^]show me the page"},
        {"path"=>["features"], "pattern"=>"[^\\^]show me the cookies"},
        {"path"=>["features"], "pattern"=>"[^\\^]show me the last email"},
        {"path"=>["features"], "pattern"=>"[^\\^]take a screenshot"},
        {"path"=>["features"], "pattern"=>"[^\\^]let me debug that"},
        {"path"=>["app", "lib"], "pattern"=>"binding.pry"},
        {"path"=>["public/javascripts"],"exclude"=>["public/javascripts/jquery", "public/javascripts/google", "public/javascripts/flowplayer", "public/javascripts/debug"], "pattern"=>"console.log"},
      ]
    end

  end
end
