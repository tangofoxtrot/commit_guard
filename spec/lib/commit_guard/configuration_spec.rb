require 'spec_helper'

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

end
