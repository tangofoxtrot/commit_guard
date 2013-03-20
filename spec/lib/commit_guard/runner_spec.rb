require 'spec_helper'

describe CommitGuard::Runner do
  let(:options) do
    double(:silent => true)
  end

  let(:runner) { described_class.new(valid_project, options) }
  describe 'initializing a new runner' do
    it 'builds a configuration using the home dir' do
      runner.configuration.config_files.first.dir.to_s.should == ENV['HOME']
    end

    it 'passes any options to the configuration object' do
      runner.configuration.should be_silent
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

  describe '#exit_status' do
    context 'given a successful run' do
      it 'returns 0' do
        runner.guardian.stub(:success? => true)
        runner.exit_status.should == 0
      end
    end

    context 'given an unsuccessful run' do
      it 'returns 1' do
        runner.guardian.stub(:success? => false)
        runner.exit_status.should == 1
      end
    end
  end
end
