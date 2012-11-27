require 'spec_helper'

describe CommitGuard::Guards::Grep do
  let(:options) do
    {'path' => ['features'], 'regex' => '@firebug'  }
  end

  let(:dir) { valid_project }
  let(:configuration) { stub(:working_dir => dir) }
  let(:guard) { described_class.new(configuration, options) }

  context 'given a valid directory' do

    it 'is valid' do
      guard.should be_valid
    end

    it 'returns the valid description' do
      guard.description.should include("Check OK")
    end
  end

  context 'given an invalid directory' do
    let(:dir) { invalid_project }

    it 'is invalid' do
      guard.should be_invalid
    end

    it 'returns the title of the guard' do
      guard.title.should == "Grep Guard"
    end

    it 'returns the invalid description' do
      guard.description.should include("Check failed: #{options['regex']}")
    end

    describe 'finding matches' do
      it 'returns the matching files in the invalid description' do
        guard.description.should include("features/login.feature")
      end

      it 'works when given one path' do
        guard = described_class.new(configuration, options.merge('path' => 'features'))
        guard.description.should include("features/login.feature")
      end
    end
  end

  describe '#paths' do
    it 'returns an array of full paths' do
      guard.paths.should == [dir.join(options['path'].first)]
    end
  end
end
