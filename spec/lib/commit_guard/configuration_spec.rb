require 'spec_helper'
require 'tempfile'

describe CommitGuard::Configuration do
  let(:options) do
    {:silent => true}
  end
  let(:configuration) { described_class.new(home_dir, valid_project, options) }

  describe 'loading the home configuration' do
    it 'does not raise an error if a config is missing' do
      expect { configuration.guards.should have(1).item }.to_not raise_error
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

  describe '#update_home' do
    before { configuration.stub(:save) }
    let(:builder_hash) { {:type => 'Awesome', :something => true} }
    let(:builder) { double(:to_hash => builder_hash) }

    it 'updates the home directory config with the builder' do
      configuration.update_home(builder)
      configuration.home_config['guards'].should include(builder_hash)
    end

    it 'saves the configuration' do
      configuration.should_receive(:save)
      configuration.update_home(builder)
    end
  end

  describe '#update_working_dir' do
    before { configuration.stub(:save) }
    let(:builder_hash) { {:type => 'Awesome', :something => true} }
    let(:builder) { double(:to_hash => builder_hash) }

    it 'updates the working directory config with the builder' do
      configuration.update_working_dir(builder)
      configuration.working_dir_config['guards'].should include(builder_hash)
    end

    it 'saves the configuration' do
      configuration.should_receive(:save)
      configuration.update_working_dir(builder)
    end
  end

  describe '#save' do
    let(:stub_home_dir_config) { Tempfile.new('home_dir') }
    let(:stub_working_dir_config) { Tempfile.new('working_dir') }
    let(:changed_config) { {:some => :changes} }

    before do
      configuration.stub(:home_dir => Pathname.new(stub_home_dir_config.path))
      configuration.stub(:working_dir => Pathname.new(stub_working_dir_config.path))
      configuration.stub(:home_config => changed_config)
      configuration.stub(:working_dir_config => changed_config)
    end

    it 'persists the home directory config to the yaml' do
      configuration.save
      YAML.load_file(stub_home_dir_config) == changed_config
    end

    it 'persists the working directory config to the yaml' do
      configuration.save
      YAML.load_file(stub_working_dir_config) == changed_config
    end
  end

end
