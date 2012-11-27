require 'spec_helper'

describe CommitGuard::Guards::Grep do
  let(:options) do
    {'path' => ['features'], 'regex' => '@firebug'  }
  end

  let(:guard) { described_class.new(dir, options) }

  context 'given a valid directory' do
    let(:dir) { valid_project }

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
        guard = described_class.new(dir, options.merge('path' => 'features'))
        guard.description.should include("features/login.feature")
      end
    end

  end
end
