require 'spec_helper'

describe CommitGuard::Configuration do
  let(:options) do
    double(:silent => true)
  end
  let(:configuration) { described_class.new(home_dir.to_s, valid_project.to_s, options) }

  describe 'loading the home configuration' do
    it 'does not raise an error if a config is missing' do
      expect { configuration.guards }.to_not raise_error
    end

    it 'reads the configuration from the .commit_guard.yml file' do
      configuration.guards.should have(1).item
    end
  end

  describe '#silent?' do
    it 'sets the silent flag from the options' do
      configuration.should be_silent
    end
  end

  describe 'loading a project with a configuration' do
    let(:configuration) { described_class.new(home_dir, invalid_project) }
    it 'reads the configuration from the .commit_guard.yml file' do
      configuration.guards.should have(2).items
    end
  end

  describe '#config_names' do
    it 'returns an array of the config names' do
      configuration.config_names.should == ['Home Directory', 'Working Directory']
    end
  end

  describe '#add_guard' do
    let(:builder_hash) { {:type => 'Awesome', :something => true} }
    let(:builder) { double(:to_hash => builder_hash) }

    it 'adds the new guard to the requested config file' do
      config_file = configuration.config_files.first
      config_file.should_receive(:save)

      configuration.add_guard(config_file.name, builder)
      config_file.guards.should include(builder_hash)
    end
  end

  describe '#pwd' do
    it 'returns the working dir path' do
      configuration.pwd.should == valid_project
    end
  end

  describe '#requires' do
    it 'returns an array of requires from the configs' do
      configuration.requires.should be_empty
    end
  end

end
