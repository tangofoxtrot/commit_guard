require 'spec_helper'

describe CommitGuard::Runner do
  let(:runner) { described_class.new(valid_project) }
  describe 'initializing a new runner' do
    it 'builds a configuration using the home dir' do
      runner.configuration.home_dir.to_s.should == ENV['HOME']
    end
    it 'initializes a new guardian with the configuration' do
      runner.guardian.configuration.should == runner.configuration
    end
  end

  describe '#run' do
    it 'delegates to the guardian' do
      runner.guardian.should_receive(:run)
      runner.run
    end
  end
end
