require 'spec_helper'

describe CommitGuard::Guards::Grep do
  let(:options) do
    {'path' => ['features'], 'regex' => '@firebug'  }
  end

  let(:dir) { valid_project }
  let(:configuration) { stub(:working_dir => dir) }
  let(:guard) { described_class.new(configuration, options) }

  describe '#yaml_name' do
    it 'returns the yaml_name of the guard' do
      guard.yaml_name.should == "Grep"
    end
  end

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
      context 'when given paths to exclude' do
        it 'excludes those matching directories from the search' do
          options['exclude'] = ['features/*']
          guard.description.should_not include("features/login.feature")
        end
      end
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

  describe '#display' do
    it 'returns the title and description' do
      guard.display.should == "#{guard.title}\n#{guard.description}"
    end
  end

  describe '.builder' do
    let(:builder) { described_class.builder }

    it 'has a pattern property' do
      builder.property_for(:pattern).should be_required
    end

    it 'has a path property' do
      builder.property_for(:path).should be_required
      builder.property_for(:path).should be_multiple
    end

    it 'has an exclude property' do
      builder.property_for(:exclude).should_not be_required
      builder.property_for(:exclude).should be_multiple
    end

  end
end
